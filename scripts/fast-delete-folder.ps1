# ---------------------------
# 💣 Fast Delete Folder
# Double-click to select and permanently delete a folder.
# ---------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# 📝 Instruction before folder selection
[System.Windows.MessageBox]::Show(
    "This tool will allow you to select a folder and permanently delete it." +
    "`n`nUse with caution! The selected folder and all its contents will be removed.",
    "Fast Delete Folder",
    "OK",
    "Warning"
) | Out-Null

# 1️⃣ Ask user to pick a folder
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select the folder you want to delete"
$folderBrowser.ShowNewFolderButton = $false

if ($folderBrowser.ShowDialog() -eq "OK") {
    $selectedPath = $folderBrowser.SelectedPath

    # Show path info in terminal
    Write-Host "📁 Selected Folder: $selectedPath" -ForegroundColor Cyan

    # 2️⃣ Confirm deletion
    $confirm = [System.Windows.MessageBox]::Show(
        "Are you sure you want to delete this folder?" + "`n`n$selectedPath",
        "Confirm Delete",
        "YesNo",
        "Warning"
    )

    if ($confirm -eq "Yes") {
        try {
            Write-Host "🧨 Deleting: $selectedPath..." -ForegroundColor Yellow
            Remove-Item -LiteralPath $selectedPath -Recurse -Force -ErrorAction Stop
            Write-Host "✅ Successfully deleted: $selectedPath" -ForegroundColor Green
            [System.Windows.MessageBox]::Show("✅ Folder deleted successfully:`n`n$selectedPath", "Success", "OK", "Info")
        }
        catch {
            Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
            [System.Windows.MessageBox]::Show("❌ Failed to delete:`n`n$selectedPath`n`nError: $($_.Exception.Message)", "Error", "OK", "Error")
        }
    }
    else {
        Write-Host "❌ Deletion cancelled by user." -ForegroundColor Red
        [System.Windows.MessageBox]::Show("Deletion cancelled.", "Cancelled", "OK", "Info")
    }
}
else {
    Write-Host "🚫 No folder selected." -ForegroundColor Red
}

# 3️⃣ Keep console open
Read-Host "`nPress Enter to exit"
