# ------------------------------------------------------------
# Uninstallation script for KCL Binary
# ------------------------------------------------------------
param (
    [string]$KCLRoot = "$Env:SystemDrive\kclvm"
)
Write-Output "Starting KCL uninstallation..."
$ErrorActionPreference = 'stop'

# Constants
$KCLCliFileName = "kcl.exe"
$KCLCliFileBinPath = "${KCLRoot}\bin"
$KCLCliFilePath = "${KCLCliFileBinPath}\${KCLCliFileName}"

# Remove KCL binary files
if (Test-Path $KCLCliFileBinPath) {
    Write-Output "Removing KCL files from $KCLCliFileBinPath"
    Remove-Item -Recurse -Force $KCLCliFileBinPath
} else {
    Write-Output "KCL binary files not found. Skipping..."
}

# Remove KCL Root if it's empty
if (Test-Path $KCLRoot) {
    if (!(Get-ChildItem -Path $KCLRoot -Recurse)) {
        Write-Output "Removing empty KCL Root directory: $KCLRoot"
        Remove-Item -Force $KCLRoot
    } else {
        Write-Output "KCL Root directory is not empty, skipping removal: $KCLRoot"
    }
}

Write-Output "KCL has been uninstalled successfully."
Write-Output "Please restart your system or log off and on for the changes to take effect."
