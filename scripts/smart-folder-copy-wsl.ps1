# ---------------------------
# 📁 Smart Folder Copy (WSL-Aware)
# Double-click to select a folder, choose a destination,
# and copy all files (excluding specified subfolders).
# ---------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# 📋 Intro message
[System.Windows.MessageBox]::Show(
  "This tool allows you to copy a folder's contents to another location." +
  "`nYou can choose which folders to ignore (like node_modules or .next)." +
  "`nYou can even copy to WSL folders like \\wsl$\\Ubuntu\\home\\joy\\projects.",
  "Smart Folder Copy",
  "OK",
  "Info"
) | Out-Null

# 🔧 Visual UNC-friendly folder picker (supports \\wsl$)
function Select-FolderDialog($description) {
  $app = New-Object -ComObject Shell.Application
  $folder = $app.BrowseForFolder(0, $description, 0, 0)
  if ($folder) {
    return $folder.Self.Path
  }
  return $null
}



# 1️⃣ Select Source
$source = Select-FolderDialog "Select the folder you want to copy"
if (-not $source) {
  Write-Host "🚫 No source folder selected." -ForegroundColor Red
  exit
}

$destination = Select-FolderDialog "Select the destination folder (can be WSL)"
if (-not $destination) {
  Write-Host "🚫 No destination folder selected." -ForegroundColor Red
  exit
}


# 3️⃣ Prompt for Ignored Folders
$excludeInput = Read-Host "Enter folder names to ignore (comma-separated, e.g. node_modules,.next)"
$excludeFolders = $excludeInput -split "," | ForEach-Object { $_.Trim() }

Write-Host "📦 Starting copy from $source to $destination..." -ForegroundColor Cyan
Write-Host "🚫 Ignoring folders: $($excludeFolders -join ", ")" -ForegroundColor Yellow

# 🕐 Start timer
$startTime = Get-Date

# 4️⃣ Filter and Copy Files
$files = Get-ChildItem -Path $source -Recurse -File -Force | Where-Object {
  $fullPath = $_.FullName
  $shouldExclude = $false
  foreach ($folder in $excludeFolders) {
    if ($fullPath -match "\\$folder\\") {
      $shouldExclude = $true
      break
    }
  }
  return -not $shouldExclude
}

$total = $files.Count
$count = 0
$failures = 0

foreach ($file in $files) {
  $relativePath = $file.FullName.Substring($source.Length).TrimStart('\')
  $targetPath = Join-Path $destination $relativePath
  $targetDir = Split-Path $targetPath

  if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  }

  try {
    Copy-Item -Path $file.FullName -Destination $targetPath -Force
  }
  catch {
    Write-Host "❌ Failed to copy: $relativePath" -ForegroundColor Red
    $failures++
  }

  $count++
  $percent = [math]::Round(($count / $total) * 100, 2)
  Write-Progress -Activity "Copying files..." -Status "$count of $total files" -PercentComplete $percent
  Write-Host "📄 Copied: $relativePath ($percent%)"
}

# ⏱️ End time and duration
$endTime = Get-Date
$duration = $endTime - $startTime

# ✅ Final summary
[System.Windows.MessageBox]::Show(
  "✅ Smart Folder Copy Completed!" +
  "`n`n📁 Source: $source" +
  "`n📂 Destination: $destination" +
  "`n📦 Files Copied: $count" +
  "`n❌ Failures: $failures" +
  "`n⏱️ Time Taken: $($duration.ToString())",
  "Smart Folder Copy - Summary",
  "OK",
  "Info"
) | Out-Null

Write-Host "`n✅ All done!" -ForegroundColor Green
Read-Host "`nPress Enter to exit"
