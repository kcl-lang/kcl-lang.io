# ------------------------------------------------------------
# Copyright 2023 The KCL Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Reference: https://github.com/dapr/cli/tree/master/install
# ------------------------------------------------------------
param (
    [string]$Version,
    [string]$KCLRoot = "$Env:SystemDrive\kclvm",
    [string]$KCLReleaseJsonUrl = "",
    [scriptblock]$CustomAssetFactory = $null
)

Write-Output ""
$ErrorActionPreference = 'stop'

#Escape space of KCLRoot path
$KCLRoot = $KCLRoot -replace ' ', '` '

# Constants
$KCLCliFileName = "kcl.exe"
$KCLCliFileBinPath = "${KCLRoot}\bin"
$KCLCliFilePath = "${KCLCliFileBinPath}\${KCLCliFileName}"

# GitHub Org and repo hosting KCL CLI
$GitHubOrg = "kcl-lang"
$GitHubRepo = "kcl"

# Set Github request authentication for basic authentication.
if ($Env:GITHUB_USER) {
    $basicAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Env:GITHUB_USER + ":" + $Env:GITHUB_TOKEN));
    $githubHeader = @{"Authorization" = "Basic $basicAuth" }
}
else {
    $githubHeader = @{}
}

if ((Get-ExecutionPolicy) -gt 'RemoteSigned' -or (Get-ExecutionPolicy) -eq 'ByPass') {
    Write-Output "PowerShell requires an execution policy of 'RemoteSigned'."
    Write-Output "To make this change please run:"
    Write-Output "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
    break
}

# Change security protocol to support TLS 1.2 / 1.1 / 1.0 - old powershell uses TLS 1.0 as a default protocol
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

# Check if KCL CLI is installed.
if (Test-Path $KCLCliFilePath -PathType Leaf) {
    Write-Warning "KCL is detected - $KCLCliFilePath"
    Invoke-Expression "$KCLCliFilePath --version"
    Write-Output "Reinstalling KCL..."
}
else {
    Write-Output "Installing KCL..."
}

# Create KCL Directory
Write-Output "Creating $KCLRoot directory"
New-Item -ErrorAction Ignore -Path $KCLRoot -ItemType "directory"
if (!(Test-Path $KCLRoot -PathType Container)) {
    throw "Cannot create $KCLRoot, without admin rights"
}

# Get the list of release from GitHub
$releaseJsonUrl = $KCLReleaseJsonUrl
if (!$releaseJsonUrl) {
    $releaseJsonUrl = "https://api.github.com/repos/${GitHubOrg}/${GitHubRepo}/releases"
}

$releases = Invoke-RestMethod -Headers $githubHeader -Uri $releaseJsonUrl -Method Get
if ($releases.Count -eq 0) {
    throw "No releases from github.com/kcl-lang/kcl repo"
}

# get latest or specified version info from releases
function GetVersionInfo {
    param (
        [string]$Version,
        $Releases
    )
    # Filter windows binary and download archive
    if (!$Version) {
        $release = $Releases | Where-Object { $_.tag_name -notlike "*rc*" } | Select-Object -First 1
    }
    else {
        $release = $Releases | Where-Object { $_.tag_name -eq "v$Version" } | Select-Object -First 1
    }

    return $release
}

# get info about windows asset from release
function GetWindowsAsset {
    param (
        $Release
    )
    if ($CustomAssetFactory) {
        Write-Output "CustomAssetFactory dectected, try to invoke it"
        return $CustomAssetFactory.Invoke($Release)
    }
    else {
        $windowsAsset = $Release | Select-Object -ExpandProperty assets | Where-Object { $_.name -Like "*windows.zip" }
        if (!$windowsAsset) {
            throw "Cannot find the windows KCL CLI binary"
        }
        [hashtable]$return = @{}
        $return.url = $windowsAsset.url
        $return.name = $windowsAsset.name
        return $return
    }`
}

$release = GetVersionInfo -Version $Version -Releases $releases
if (!$release) {
    throw "Cannot find the specified KCL CLI binary version"
}
$asset = GetWindowsAsset -Release $release
$zipFileUrl = $asset.url
$assetName = $asset.name

$zipFilePath = $KCLRoot + "\" + $assetName
Write-Output "Downloading $zipFileUrl ..."

$githubHeader.Accept = "application/octet-stream"
$oldProgressPreference = $progressPreference;
$progressPreference = 'SilentlyContinue';
Invoke-WebRequest -Headers $githubHeader -Uri $zipFileUrl -OutFile $zipFilePath
$progressPreference = $oldProgressPreference;
if (!(Test-Path $zipFilePath -PathType Leaf)) {
    throw "Failed to download KCL binary - $zipFilePath"
}

# Extract KCL CLI to $KCLRoot
Write-Output "Extracting $zipFilePath..."
Microsoft.Powershell.Archive\Expand-Archive -Force -Path $zipFilePath -DestinationPath $KCLRoot
if (!(Test-Path $KCLCliFilePath -PathType Leaf)) {
    throw "Failed to download KCL archieve - $zipFilePath"
}

# Clean up zipfile
Write-Output "Clean up $zipFilePath..."
Remove-Item $zipFilePath -Force

# Add KCLRoot directory to User Path environment variable
Write-Output "Try to add $KCLRoot to User Path Environment variable..."
$UserPathEnvironmentVar = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPathEnvironmentVar -like '*kcl*') {
    Write-Output "Skipping to add $KCLRoot to User Path - $UserPathEnvironmentVar"
}
else {
    [System.Environment]::SetEnvironmentVariable("PATH", $UserPathEnvironmentVar + ";$KCLRoot", "User")
    [System.Environment]::SetEnvironmentVariable("PATH", $UserPathEnvironmentVar + ";$KCLCliFileBinPath", "User")
    $UserPathEnvironmentVar = [Environment]::GetEnvironmentVariable("PATH", "User")
    Write-Output "Added $KCLRoot to User Path - $UserPathEnvironmentVar"
    Write-Output "Added $KCLCliFileBinPath to User Path - $UserPathEnvironmentVar"
}

Write-Output "`r`nKCL is installed successfully."
Write-Output "To get started with KCL, please visit https://kcl-lang.io/docs/user_docs/getting-started/kcl-quick-start ."
Write-Output "Ensure that Docker Desktop is set to Linux containers mode when you run KCL in self hosted mode."
