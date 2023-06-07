[CmdletBinding()]
param (
    [Parameter()][String]$Version
)

$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

if (!$Version) {
    $Version = "0.0.0"
}

Write-Output "Version: $Version"

$FullPath = Resolve-Path $PSScriptRoot\..\src\VisualStudio.ExtensionPack.22\source.extension.vsixmanifest
Write-Output $FullPath
[xml]$content = Get-Content $FullPath
$content.PackageManifest.Metadata.Identity.Version = $Version
$content.Save($FullPath)
