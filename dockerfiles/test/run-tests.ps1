param(
    [string] $Path,
    [string] $Where
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$testProject = 'PartsUnlimited.Tests'
$binPath = Join-Path $Path "$testProject\bin\*" -Resolve
$testDllPath = Join-Path $binPath "$testProject.dll"

# change connection string
$configPath = "$testDllPath.config"
[xml] $config = Get-Content $configPath
$cnn = $config.configuration.connectionStrings.add | Where-Object name -eq 'PartsUnlimitedContext'
$cnn.connectionString = "Server=db;Database=PartsUnlimited;uid=sa;pwd=$env:sa_password;"
$config.Save($configPath)


$outputPath = 'C:\results'

# cleanup from previous executions
Remove-Item "$outputPath\*" 

# run tests
$env:Path = (Resolve-Path "$Path\packages\NUnit.ConsoleRunner.*\tools").Path + ';' + $env:Path
$params = $testDllPath, "--work=$outputPath", '--inprocess'
if ($Where) {
    $params += '--where', ('"{0}"' -f $Where)
}
nunit3-console @params
$testsExitCode = $LASTEXITCODE

# create html test report
$env:Path = (Resolve-Path "$Path\packages\ReportUnit.*\tools").Path + ';' + $env:Path
reportunit "$outputPath\TestResult.xml" "$outputPath\TestReport.html"
$reportExitCode = $LASTEXITCODE


if ($reportExitCode -gt 0) {
    throw "Error creating test report; exit code: $reportExitCode"
}
if ($testsExitCode -lt 0) {
    Write-Warning "Unexpected error from nunit3-console; exit code: $testsExitCode"
    $host.SetShouldExit($testsExitCode)
    exit
}
if ($testsExitCode -gt 0) {
    Write-Warning "Test failure count: $testsExitCode"
    $host.SetShouldExit($testsExitCode + 1)
    exit
}