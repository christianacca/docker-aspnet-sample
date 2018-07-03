param(
    [string] $Configuration,
    [bool] $SkipPull,
    [bool] $Force
)

$imageName = 'aspnetapp-sample'
$registryAccount = 'christianacca'
$repo = "$registryAccount/$imageName"
$repoLatestTag = "$repo`:latest"
$env:BUILD_BASE_IMAGE = 'christianacca/dotnet-framework:4.7.2-sdk'
$env:RUNTIME_BASE_IMAGE = 'microsoft/aspnet:4.7.2'

$isLatest = ($env:BH_CommitMessage -match '!deploy' -and $ENV:BH_BranchName -eq "master")

$branchSuffix = ($env:BH_BranchName -replace '/', '-')
$composeTestProject = "$imageName-$branchSuffix-test"
$integrationComposeConfig = '-p', $composeTestProject, '-f', "$BuildRoot\dockerfiles\test\docker-compose.yml"

Task Default Build
Task CI Build, ?Test, PublishTestResults, Teardown, ThrowOnTestFailure, Publish
Task Test Build, IntegrationTest


function ComposeUp {
    param([string] $Name)

    $VerbosePreference = 'Continue'

    exec { docker-compose -f $BuildRoot\docker-compose.yml -p $Name up -d }

    $containerName = '{0}_web-app_1' -f $Name
    Wait-DockerContainerStatus $containerName -Status healthy -Timeout 60 -Interval 10 -Verbose 
    $ip = (Get-DockerContainerIP $containerName).IPAddress
    $url = "http:\\$ip"
    Write-Information "Opening '$url'"
    Start-Process  chrome.exe -ArgumentList @( '-incognito', $url )
}

function ComposeDown {
    param([string] $Name)
    exec { docker-compose -p $Name -f $BuildRoot\docker-compose.yml down }
}

Enter-Build {
    "  Branch: $env:BH_BranchName"
    "  Configuration: $Configuration"
}

# Synopsis: Build docker image
task Build SetVersionVars, {
    "  Building $version"

    # set docker build-args
    $env:VS_CONFIG = $Configuration

    $composeFile = "$BuildRoot\dockerfiles\build\docker-compose.yml"
    if ($BuildTask -in 'Test') {
        exec { docker-compose -f $composeFile build 'build-env' }
    } else {
        # set docker build-args
        $env:IMAGE_TAG = $repoTags | Select-Object -First 1

        exec { docker-compose -f $composeFile build }
        
        $repoTags | Select-Object -Skip 1 | ForEach-Object {
            exec { docker tag $env:IMAGE_TAG $_ }
        }
    }
}

# Synopsis: Removes docker artefacts created by the build
task Cleanup {
    exec { docker image prune -f }
    $imageId = @(exec { docker image ls -f reference=$repo -q })
    $imageId += exec { docker image ls -f reference=$imageName -q }
    $imageId = $imageId | Select-Object -Unique

    $containerId = @($imageId | ForEach-Object { 
        exec { docker container ls -f ancestor=$_ -q -a }
    })
    $containerId | ForEach-Object {
        exec { docker container rm -v -f $_ }
    }
    $imageId | ForEach-Object {
        exec { docker image rm -f $_ }
    }
}

task Down {
    ComposeDown -Name $imageName
}

task DownDev {
    try {
        $env:VERSION = 'dev'
        ComposeDown -Name "$imageName-dev"
    }
    finally {
        Remove-Item Env:\VERSION
    }
}

# Synopsis: Display environment details of the computer on which the build is running
task EnvironInfo {
    Get-BuildEnvironmentDetail -KillKittens
                
    $more = @{}
    $more.set_item('Environ Variables', (Get-ChildItem env:\))
    $more.set_item('Docker', (exec { docker version }))
    
    $lines = '----------------------------------------------------------------------'
    foreach($key in $more.Keys)
    {
        "`n$lines`n$key`n`n"
        $more.get_item($key) | Out-Host
    }
}


# Synopsis: Run the integration tests against the containerized build output
task IntegrationTest {
    exec { 
        docker-compose @integrationComposeConfig up --build --force-recreate `
            --abort-on-container-exit --exit-code-from tests 
    }
}

# Synopsis: Login to the docker registry that stores the docker image produced by the Build task
task Login {
    $DockerUsername = (property DockerUsername)
    $DockerPassword = (property DockerPassword)
    
    "  Login to docker hub"
    exec { docker login -u $DockerUsername -p $DockerPassword }
}

# Synopsis: Logout of the docker registry
task Logout {
    "  Logout from docker hub"
    exec { docker logout $registryAccount }
}

# Synopsis: Open the html test result report
task OpenTestResult SetTestOutputVars, {
    Invoke-Item $testResultsHtmlPath
}

# Synopsis: Publishes the docker image to the registry
task Publish Build, Login, {

    # Gate deployment
    if (!$isLatest -and !$Force)
    {
        "Skipping deployment: To deploy, ensure that...`n" + 
        "`t* You are committing to the master branch (Current: $ENV:BH_BranchName) `n" + 
        "`t* Your commit message includes !deploy (Current: $ENV:BH_CommitMessage)"
        return
    }

    $repoTags | ForEach-Object {
        "  Pushing $_"
        exec { docker push $_ }
    }
}

# Synopsis: Publishes the test results to the CI server
task PublishTestResults SetTestOutputVars, {
    switch ($env:BH_BuildSystem) {
        'VSTS' { Write-Host "##vso[task.setvariable variable=TestResultsFilePath]$testResultsXmlPath"; break }
    }
}

# Synopsis: Sets the CI build number for the current build being executed by the CI build server
task SetCiBuildNumber -After SetVersionVars -If ($env:BH_BuildSystem -ne 'Unknown') {
    switch ($env:BH_BuildSystem) {
        'VSTS' { Write-Host ('##vso[build.updatebuildnumber]{0}+{1}' -f $version,  $env:BH_BuildNumber); break }
    }
}

# Synopsis: Sets script variables with the paths to the test output
task SetTestOutputVars {
    $script:testOutputPath = (Get-DockerVolume -ContainerName "$($composeTestProject)_tests_1").Mountpoint
    $script:testResultsHtmlPath = Join-Path $testOutputPath 'TestResult.html'
    $script:testResultsXmlPath = Join-Path $testOutputPath 'TestResult.xml'
}

# Synopsis: Sets script variables with the semantic version of the current checked out git branch
task SetVersionVars {
    $script:version = Get-Content "$BuildRoot\src\version.txt" -Raw
    $buildTag = if ($env:BH_BuildSystem -ne 'Unknown') { "$version-build$env:BH_BuildNumber" } else { 'dev' }
    $latestTag = if ($isLatest) { 'latest' }
    $script:tags = @($version, $buildTag, $latestTag) | Where-Object { $_ }
    $script:repoTags = $tags | ForEach-Object { '{0}:{1}' -f $repo, $_ }
}

# Synopsis: Remove docker containers and volumes created by the tests
task Teardown {
    exec { docker-compose @integrationComposeConfig down -v }
}

# Synopsis: Prevent subsequent task execution in cases where tests have failed
task ThrowOnTestFailure {
    assert(-not(error IntegrationTest)) "Testing quality gate failed"
}

# Synopsis: Pull the latest base images used by our containers
task UpdateBaseImages -Before Build -If ($SkipPull -eq $false) {
    foreach ($baseImage in @($env:BUILD_BASE_IMAGE, $env:RUNTIME_BASE_IMAGE)) {
        exec { docker pull $baseImage }
    }
}

task Up {
    ComposeUp -Name $imageName
}

task UpDev {
    try {
        $env:VERSION = 'dev'
        ComposeUp -Name "$imageName-dev"
    }
    finally {
        Remove-Item Env:\VERSION
    }
}

# Synopsis: Return the semantic version number and resulting docker tag for the current checked out git branch
task VersionInfo SetVersionVars, {
    [ordered]@{
        Build          = $version
        DockerTags     = $tags
    }
}