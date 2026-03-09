<div align="center">
  <table>
    <tr>
      <td align="center" bgcolor="#2f2f2f">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/FFmpeg_Logo_new.svg/500px-FFmpeg_Logo_new.svg.png" height="300" alt="FFmpeg logo" />
        <img src="PASTE_POWERSHELL_LOGO_URL_HERE" height="300" alt="PowerShell logo" />
      </td>
    </tr>
  </table>
</div>

# FFmpeg PowerShell Utilities

Small Windows PowerShell utilities for installing FFmpeg, updating FFmpeg, and joining video files with FFmpeg.

## Compatibility

- **Operating system:** Windows only
- **Minimum PowerShell version:** Windows PowerShell 5.1
- **FFmpeg requirement for join script:** `ffmpeg.exe` must already be available in `PATH`

## Scripts

### `install-ffmpeg.ps1`

Downloads the latest shared GPL Windows FFmpeg build, extracts it into your user profile, and adds the FFmpeg `bin` directory to your **user** `PATH`.

#### What it does

- Downloads the latest FFmpeg build archive.
- Extracts FFmpeg into your user profile.
- Adds the extracted `bin` folder to the current user's `PATH`.
- Refuses to continue unless you acknowledge the script's actions with a safety switch.

#### Usage

```powershell
powershell -ExecutionPolicy Bypass -File .\install-ffmpeg.ps1 -iAgreeAndAcknowledgeRisks



# update-ffmpeg.ps1

Update FFmpeg on Windows by removing the existing user-profile installation, downloading the latest build, extracting it, and re-adding the FFmpeg `bin` directory to the current user's `PATH`.

## Requirements

- Windows
- Windows PowerShell 5.1 or newer
- Internet connection
- Permission to modify your user profile folder and user `PATH`

## Safety Acknowledgement

This script requires the `-iAgreeAndAcknowledgeRisks` switch before it will run.

If the switch is not provided, the script prints a warning message and exits.

## Usage

### Basic usage

```powershell
powershell -ExecutionPolicy Bypass -File .\update-ffmpeg.ps1 -iAgreeAndAcknowledgeRisks



# ffmpeg-join-video-files.ps1

Join multiple video files into a single `.mp4` or `.mkv` output using FFmpeg.
This script autofixes timestamps.

## Requirements

- Windows
- Windows PowerShell 5.1 or newer
- `ffmpeg.exe` available in your `PATH`
- Enough free disk space for temporary working files (approximately 2x the total size of all input files)

## Script Parameters

### `-inputListFile`

Path to a text file containing the list of input video files.

Rules:

- Must end with `.txt`
- Must already exist

### `-outputFile`

Path to the final output video file.

Rules:

- Must end with `.mp4` or `.mkv`
- The destination directory must already exist

## Input List File Format

Create a text file list.txt file in this format:

```text
file 'C:\Videos\clip01.mp4'
file 'C:\Videos\clip02.mp4'
file 'C:\Videos\clip03.mp4'

```powershell
powershell -ExecutionPolicy Bypass -File .\ffmpeg-join-video-files.ps1 -inputListFile .\list.txt -outputFile C:\Videos\joined.mp4
