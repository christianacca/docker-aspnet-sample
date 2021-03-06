<#
.Description
Installs and loads all the required modules for the build.

.PARAMETER Configuration
MSBuild configuration

.PARAMETER Credential
Docker credentials to login to the 'series5.azurecr.io' registry

.PARAMETER SkipPull
Skip pulling base image(s) before building

.PARAMETER Force
Change the behaviour of the Task being run:
* Publish: publish when otherwise it would be skipped?
* Up, UpDev: remove any existing containers rather than starting them
* Down, DownDev: also remove volumes

#>

[cmdletbinding()]
param (
    [ValidateSet('Build', 'CI', 'Cleanup', 'Down', 'DownDev', 'EnvironInfo', 'Help', 'Login', 'Logout', 'OpenTestResult', 'Publish', 'Test', 'VersionInfo', 'Up', 'UpDev')]
    [string[]] $Task = 'Default',

    [string] $Configuration = 'Release',

    [pscredential] $Credential,

    [switch] $SkipPull,

    [switch] $Force
)

$InformationPreference = 'Continue'; $WarningPreference = 'Continue'

Write-Output "Starting build"

if (-not (Get-PackageProvider | ? Name -eq nuget)) {
    Write-Output "  Install Nuget PS package provider"
    Install-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
}

# Grab nuget bits, install modules, set build variables, start build.
Write-Output "  Install And Import Build Modules"
$psDependVersion = '0.2.0'
if (-not(Get-InstalledModule PSDepend -RequiredVersion $psDependVersion -EA SilentlyContinue)) {
    Install-Module PSDepend -RequiredVersion $psDependVersion -Force -Scope CurrentUser
}
Import-Module PSDepend -RequiredVersion $psDependVersion
Invoke-PSDepend -Path "$PSScriptRoot\build.depend.psd1" -Install -Force

if ($Task -eq 'Help') {
    Invoke-Build ?
    return
}

Set-BuildEnvironment -Force -VariableNamePrefix 'BH_' -BuildOutput "$PSScriptRoot\output" -WA SilentlyContinue

Write-Output '  Setting build script properties'
if ($Credential) {
    $env:DockerUsername = $Credential.UserName
    $env:DockerPassword = $Credential.GetNetworkCredential().Password
}

Write-Output "  InvokeBuild"
Invoke-Build $Task -Configuration $Configuration -Force $Force -SkipPull $SkipPull -Result result
if ($Result.Error) {
    exit 1
}
else {
    exit 0
}