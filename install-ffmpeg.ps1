param(
   [switch]$iAgreeAndAcknowledgeRisks
)

if (-not $iAgreeAndAcknowledgeRisks){
    Write-Host "

Running this script will take the following actions:

- An open Source application provided by https://www.ffmpeg.org/ will be extacted into your user profile.
- The directory containing the FFMPEG binaries will be added to your user account's PATH environment variable.

This script comes with no warrenty!

To proceed please re-run this script with the switch -iAgreeAndAcknowledgeRisks

Example:

.\install-ffmpeg.ps1 -iAgreeAndAcknowledgeRisks 
  
"
    exit 0
}


$url  = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"
$zipFile = "$env:userprofile\ffmpeg.zip"
$detinationPath = "$env:userprofile\ffmpeg"
$ffmpegBinDir = "$env:userprofile\ffmpeg\ffmpeg-master-latest-win64-gpl-shared\bin"

if (Test-Path "$ffmpegBinDir\ffmpeg.exe"){
    Write-host "
    
    FFMPEG is already installed, please use ffmpeg-update.ps1 to 
    uninstall FFMPEG and upgrade to the latest release of FFMPEG."
    
    exit 0
}

try{
    Write-host "Attempting to download FFMPEG zip file..."
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Write-Host "Download completed!
Extracting FFMPEG zip file to user profile home folder."
    Expand-Archive -Path $zipFile -DestinationPath $detinationPath
    Remove-Item -Path "$env:userprofile\ffmpeg.zip"
}
catch{
    Write-Host "Downloading or zip extraction failure."
    exit 1

}


##  Including FFMPEG in the user environment PATH variable.

$currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User')

$paths = @()
if ($currentUserPath) {
    $paths = $currentUserPath -split ';'
}

if ($paths -notcontains $ffmpegBinDir) {
    try{
        write-Host "Attempting to add FFMPEG bin directory to the user account PATH environment variable"
        $newUserPath = (($paths + $ffmpegBinDir) | Where-Object { $_ }) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User')

        if (($env:Path -split ';') -notcontains $ffmpegBinDir) {
            $env:Path = (($env:Path -split ';') + $ffmpegBinDir | Where-Object { $_ }) -join ';'
            }
        } 
        catch {
        Write-host "A problem occured while attempting to add FFMPEG bin directory to the user account PATH environment variable"
        exit 1
    }
}

Write-host "The script has completed, you can now enjoy your new install of FFMPEG!"

$env:Path="$ffmpegBinDir;$env:Path"
