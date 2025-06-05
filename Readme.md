# 🚀 PowerShell Utilities

Quick PowerShell Toolkit\*\* — two fast and reliable scripts to help you effortlessly manage folders on Windows:

- 💣 **Fast Delete Folder** — Select and permanently delete any folder with ease
- 📁 **Smart Folder Copy** — Copy folders with drag-and-exclude options, plus progress feedback

---

## ✨ Why I Created These Tools

As a developer, I often face these painful bottlenecks:

- **Slow folder deletions**, especially with huge `node_modules` or bulky project directories, causing frustration and wasted time.
- **Inefficient folder copying** that drags when including large unwanted folders like `node_modules` or build caches, especially on aging or failing hard drives.
- The need for **simple, fast, and reliable utilities** to speed up routine tasks without installing heavy software or complicated setups.

So I built these **lightweight PowerShell scripts** to:

- **Quickly and safely delete any folder** with confirmation, avoiding common mistakes and speed limitations.
- **Copy only what matters** by excluding heavy folders (like `node_modules`) during recursive copies, dramatically improving speed and reducing disk wear.
- Provide **clear visual progress and friendly dialogs** so users know exactly what’s happening.
- Ensure they **work on any Windows machine with minimal setup**—pure PowerShell and built-in dialogs.

These tools save me hours during development and deployment, and I’m confident they’ll do the same for you.

---

## 💣 Fast Delete Folder

### 📝 Overview

A no-nonsense PowerShell script to quickly pick any folder and **permanently delete** it after your confirmation — safe, visual, and lightning-fast.

### ⚙️ Features

- User-friendly folder picker dialog
- Double confirmation prompt to avoid accidents
- Colorful terminal logs with success/error feedback
- Message boxes for user-friendly alerts
- Keeps console open after execution

### 🚀 Usage

1. Run or double-click `fast-delete-folder.ps1`
2. Select the folder you want to delete
3. Confirm deletion when prompted
4. The folder will be deleted instantly
5. Review success or cancellation messages
6. Press Enter to exit the console

---

## 📁 Smart Folder Copy

### 📝 Overview

Copy any folder with the power to **exclude unwanted subfolders** like `node_modules` or `.next`. Get detailed progress and a summary when done.

### ⚙️ Features

- Graphical source & destination folder selection
- Specify folder names to exclude (comma-separated)
- Recursively copies files, skipping excluded folders
- Real-time progress bar & file-by-file copy status
- Summary dialog with total copied files & failures
- Console stays open until user exits

### 🚀 Usage

1. Run or double-click `smart-folder-copy.ps1`
2. Select the folder to copy (source)
3. Select the destination folder
4. Enter folder names to exclude (e.g., `node_modules,.next`)
5. Watch progress and copied file logs
6. Review summary popup at completion
7. Press Enter to close
