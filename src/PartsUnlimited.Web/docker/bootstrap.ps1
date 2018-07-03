$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

Write-Host 'docker.bootstrap.ps1...'

# change connection string
Write-Host '  Set db connection string'
$configPath = "web.config"
[xml] $config = Get-Content $configPath
$cnn = $config.configuration.connectionStrings.add | Where-Object name -eq 'PartsUnlimitedContext'
$cnn.connectionString = "Server=$env:DB_SERVER;Database=PartsUnlimited;uid=sa;pwd=$env:sa_password;"
$config.Save($configPath)

Write-Host '  Startup ServiceMonitor.exe'
C:\ServiceMonitor.exe w3svc

Write-Host 'docker.bootstrap.ps1... ' -NoNewline
Write-Host 'done' -ForegroundColor Green