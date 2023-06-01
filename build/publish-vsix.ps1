[CmdletBinding()]
param (
    [Parameter()][String]$PersonalAccessToken
)

$VsixPath = "$PSScriptRoot\..\src\VisualStudio.ExtensionPack.22\bin\Release\Aqovia.VisualStudio.ExtensionPack.vsix"
$ManifestPath = "$PSScriptRoot\extension-manifest.json"

$VSInstallation = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" `
    -latest -prerelease -format json | ConvertFrom-Json
$VSInstallationPath = $VSInstallation.installationPath

Write-Host "Visual Studio installation path: $VSInstallationPath"
$VsixPublisher = Join-Path -Path $VSInstallationPath `
    -ChildPath "VSSDK\VisualStudioIntegration\Tools\Bin\VsixPublisher.exe" `
    -Resolve

Write-Host "VsixPublisher path: $VsixPublisher"

$VsixPublisherExists = Test-Path $VsixPublisher
if (!$VsixPublisherExists) {
    Write-Host "VsixPublisher path doesn't exist."
}
else {
    & $VsixPublisher publish `
        -payload $VsixPath `
        -publishManifest $ManifestPath `
        -personalAccessToken $PersonalAccessToken `
        -ignoreWarnings "VSIXValidatorWarning01,VSIXValidatorWarning02,VSIXValidatorWarning08"
}
