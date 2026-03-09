#This script requires you to have the total sum of the size of the input video files x2
#for example if you want to join 4 files each 250MB in size you will need 2GB of free disk space

param(
    [Parameter(Mandatory = $true, HelpMessage = "Path to a text file listing the video files to be joined. Example: C:\temp\list.txt")]
    [ValidateScript({
        if ($_ -notmatch '(?i)\.txt$') {
            throw "The value of -inputListFile must end with .txt"
        }

        if (-not (Test-Path $_ -PathType Leaf)) {
            throw "-inputListFile the file was not found: $_"
        }

        $true
    })]
    [string]$inputListFile,

    [Parameter(Mandatory = $true, HelpMessage = "Output video file path, e.g. C:\temp\joined.mp4")]
    [ValidateScript({
    if ($_ -notmatch '(?i)\.(mp4|mkv)$') {
        throw "outputFile must end with .mp4 or .mkv"
    }

    $parent = Split-Path -Path $_ -Parent

    if ([string]::IsNullOrWhiteSpace($parent)) {
        throw "outputFile must include a destination directory"
    }

    if (-not (Test-Path -Path $parent -PathType Container)) {
        throw "Destination directory does not exist: $parent"
    }

    $true
})]
    [string]$outputFile
)

echo "" > .\processing-file.txt

gc $inputListFile | foreach {
    $fileName = (($_).ToString()).Split()[1]

try {
    Write-Host "Preping files to be joined"
    & ffmpeg -i $fileName -c copy -y -loglevel error ("output_" + $fileName.Split("\")[4]).Replace('"','')  
    $processedFile = echo ("output_" + $fileName.Split("\")[-1]).Replace('"','') 
    echo "file '$processedFile'" >> .\processing-file.txt
    Write-Host "Done! Processing: " (($_).ToString()).Split()[1]
}
catch {
    Write-Error ("FFmpeg failed to process: " + $fileName)
    Remove-Item .\processing-file.txt
    exit 1
}
} 

try {
    write-host "ffmpeg is attempting to join the video files."
    gc .\processing-file.txt | out-file -Encoding ascii -FilePath .\processing-list.txt
    Remove-Item .\processing-file.txt
    ffmpeg -f concat -safe 0 -i .\processing-list.txt -c copy -y -loglevel error $outputFile
    write-host "Joining video files completed."
}
catch {
    write-host "ffmpeg failed to join the video files."
    Remove-Item .\processing-list.txt
    exit 1
}

try {
    Write-Host "Starting cleanup of working files."
    gc .\processing-list.txt | where {$_ -match "mkv" -or $_ -match "mp4" } | foreach {$theFileName = (($_).ToString()).Split()[1].Replace("'",''); Remove-item $theFileName}
    Remove-Item .\processing-list.txt
    Write-Host "Everything completed!"
}
catch {
    write-host "ffmpeg has join the video files, but post script cleanup has failed."
    exit 1
}
