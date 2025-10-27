Add-Type -AssemblyName System.Windows.Forms

Write-Host "🎬 Zetta Chapter Embedder (MP4 + MKV Compatible)"
Write-Host "───────────────────────────────────────────────"
Write-Host "Paste your timestamps below (format: 2:10 Opening VIM)"
Write-Host "When done, press ENTER twice to finish input."
Write-Host ""

# --- Collect timestamps ---
$timestamps = @()
while ($true) {
  $line = Read-Host
  if ([string]::IsNullOrWhiteSpace($line)) { break }
  $timestamps += $line
}

if ($timestamps.Count -eq 0) {
  Write-Host "❌ No timestamps provided. Exiting..."
  pause
  exit
}

# --- Convert to seconds ---
function Convert-ToSeconds($timeString) {
  if ($timeString -match '^(\d+):(\d+):(\d+)$') {
    return [int]$matches[1] * 3600 + [int]$matches[2] * 60 + [int]$matches[3]
  }
  elseif ($timeString -match '^(\d+):(\d+)$') {
    return [int]$matches[1] * 60 + [int]$matches[2]
  }
  else {
    Write-Host "⚠️ Invalid timestamp format: $timeString"
    return 0
  }
}

# --- Parse entries ---
$entries = @()
foreach ($line in $timestamps) {
  if ($line -match '^(\d+:\d+(?::\d+)?)\s+(.+)$') {
    $entries += [PSCustomObject]@{
      Start = Convert-ToSeconds $matches[1]
      Title = $matches[2].Trim()
    }
  }
}

if ($entries.Count -eq 0) {
  Write-Host "❌ No valid timestamps found."
  pause
  exit
}

# --- Create ffmetadata file ---
$metaLines = @(";FFMETADATA1")
for ($i = 0; $i -lt $entries.Count; $i++) {
  $start = $entries[$i].Start
  $title = $entries[$i].Title
  $end = if ($i -lt $entries.Count - 1) { $entries[$i + 1].Start - 1 } else { $start + 60 }

  $metaLines += "[CHAPTER]"
  $metaLines += "TIMEBASE=1/1"
  $metaLines += "START=$start"
  $metaLines += "END=$end"
  $metaLines += "title=$title"
  $metaLines += ""
}

$metaFile = Join-Path $env:TEMP "chapters.ffmeta"
$metaLines | Set-Content -Path $metaFile -Encoding UTF8

# --- Pick video file ---
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "Video Files|*.mp4;*.mkv;*.mov;*.avi"
$dialog.Title = "Select the video file to add chapters to"
if ($dialog.ShowDialog() -ne "OK") {
  Write-Host "❌ No file selected. Exiting..."
  pause
  exit
}

$inputVideo = $dialog.FileName
$tempFile = [System.IO.Path]::Combine(
  [System.IO.Path]::GetDirectoryName($inputVideo),
  ([System.IO.Path]::GetFileNameWithoutExtension($inputVideo) + "_temp" + [System.IO.Path]::GetExtension($inputVideo))
)

$inputQuoted = '"' + $inputVideo + '"'
$tempQuoted = '"' + $tempFile + '"'
$metaQuoted = '"' + $metaFile + '"'

Write-Host "`n⚙️ Embedding chapters into: $inputVideo"
Write-Host ""

# --- Run ffmpeg with ffmetadata ---
$cmd = "ffmpeg -y -i $inputQuoted -i $metaQuoted -map_metadata 1 -codec copy -movflags use_metadata_tags $tempQuoted"
Write-Host "▶ Running: $cmd`n"
cmd /c $cmd

# --- Replace original file ---
if (Test-Path $tempFile) {
  Move-Item -Force $tempFile $inputVideo
  Write-Host "✅ Chapters successfully embedded into original file!"
  Write-Host "📁 File: $inputVideo"

  # --- Verify ---
  Write-Host "`n🔍 Verifying embedded chapters..."
  $verifyCmd = "ffprobe -v error -show_chapters -print_format json $inputQuoted"
  cmd /c $verifyCmd
}
else {
  Write-Host "❌ FFmpeg failed or chapters were not embedded."
}

pause
