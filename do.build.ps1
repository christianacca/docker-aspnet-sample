param(
    [string] $Configuration,
    [bool] $SkipPull,
    [bool] $Force
)

$imageName = 'aspnetapp-sample'
$registryAccount = 'christianacca'
$repo = "$registryAccount/$imageName"
$env:BUILD_BASE_IMAGE = 'microsoft/dotnet-framework:4.7.2-sdk'
$env:RUNTIME_BASE_IMAGE = 'microsoft/aspnet:4.7.2'
$env:DB_IMAGE_TAG = 'christianacca/mssql-server-windows-express'

$isLatest = ($env:BH_CommitMessage -match '!deploy' -and $ENV:BH_BranchName -eq "master")
$branchName = ($env:BH_BranchName -replace '/', '-')

$composeTestProject = "$imageName-$branchName-test"
$composeTestPath = "$BuildRoot\dockerfiles\test"
$integrationComposeConfig = '-p', $composeTestProject, '-f', "$composeTestPath\docker-compose.yml"

Task Default Build
Task CI Build, ?Test, PublishTestResults, TeardownTests, ThrowOnTestFailure, Publish
Task Test Build, IntegrationTest


function ComposeUp {
    param([string] $Name)

    $VerbosePreference = 'Continue'

    $recreateContainers = if ($Force) { '--force-recreate' }
    exec { docker-compose -f $BuildRoot\docker-compose.yml -p $Name up -d $recreateContainers }

    $containerName = '{0}_web-app_1*' -f $Name
    # note: we are having to wait 2 mins as the web app creates the db on first startup
    Wait-DockerContainerStatus $containerName -Status healthy -Timeout 120 -Interval 10 -Verbose 
    $ip = (Get-DockerContainerIP $containerName).IPAddress
    $url = "http:\\$ip"
    Write-Information "Opening '$url'"
    Start-Process  chrome.exe -ArgumentList @( '-incognito', $url )
}

function ComposeDown {
    param([string] $Name)
    $removeVolume = if ($Force) { '-v' }
    exec { docker-compose -p $Name -f $BuildRoot\docker-compose.yml down $removeVolume }
}

function RunTestsInDocker {
    param([string[]] $Configuration)
    exec { docker-compose @Configuration down -v --remove-orphans }
    exec { docker-compose @Configuration up --build --abort-on-container-exit --exit-code-from tests }
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

    exec { docker-compose -f $BuildRoot\dockerfiles\build\docker-compose.yml build }

    if ($BuildTask -notlike '*Test') {
        # set docker build-args
        $env:IMAGE_TAG = $repoTags | Select-Object -First 1

        exec { docker-compose -f $BuildRoot\dockerfiles\build\compose-runtime.yml build }
    }
}

# Synopsis: Removes docker artefacts created by the build
task Cleanup TeardownTests, {
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

# Synopsis: Calls docker-compose down to stop containers, removes containers, networks, volumes, and images created by Up
task Down {
    ComposeDown -Name $imageName
}

# Synopsis: Calls docker-compose down to stop containers, removes containers, networks, volumes, and images created by UpDev
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
    RunTestsInDocker $integrationComposeConfig
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
task Publish @{
    If = {
        # Gate deployment
        $skip = !$isLatest -and !$Force
        if ($skip) {
            Write-Information "Skipping deployment: To deploy, ensure that...`n" + 
            Write-Information "`t* You are committing to the master branch (Current: $ENV:BH_BranchName) `n" + 
            Write-Information "`t* Your commit message includes !deploy (Current: $ENV:BH_CommitMessage)"
        }
        !$skip
    }
    Jobs = 'Build', 'Login', {
        $repoTags | Select-Object -Skip 1 | ForEach-Object {
            exec { docker tag $env:IMAGE_TAG $_ }
        }
    
        $repoTags | Where-Object { $_ -notlike '*:dev' } | ForEach-Object {
            "  Pushing $_"
            exec { docker push $_ }
        }
    }
}

# Synopsis: Publishes the test results to the CI server
task PublishTestResults SetTestOutputVars, {
    switch ($env:BH_BuildSystem) {
        'VSTS'
        {
            Write-Host "##vso[task.setvariable variable=TestResultsSearchPath;isOutput=true;]$testOutputPath"
            break
        }
        'AppVeyor'
        { 
            $webClient = New-Object 'System.Net.WebClient'
            try {
                $webClient.UploadFile(
                    "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
                    $testResultsXmlPath )
            }
            finally {
                $webClient.Dispose()    
            }
            break
        }
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

    @($testResultsHtmlPath, $testResultsXmlPath) | ForEach-Object {
        if (Test-Path $_) {
            Write-Information "Test results file created: $_"
        } else {
            Write-Warning "Missing test results file: $_"
        }
    }
}

# Synopsis: Sets script variables with the semantic version of the current checked out git branch
task SetVersionVars {
    $script:version = Get-Content "$BuildRoot\src\version.txt" -Raw
    $script:versionTags = & {
        $version
        if ($env:BH_BuildSystem -ne 'Unknown') { "$version-$env:BH_BuildNumber" }
    }
    $script:tags = & {
        if ($env:BH_BuildSystem -eq 'Unknown') { 'dev' }
        $branchName
        $versionTags
        if ($isLatest) { 'latest' }
    }
    $script:repoTags = $tags | ForEach-Object { '{0}:{1}' -f $repo, $_ }
    $script:versionRepoTags = $versionTags | ForEach-Object { '{0}:{1}' -f $repo, $_ }
}

# Synopsis: Remove docker containers and volumes created by the tests
task TeardownTests {
    exec { docker-compose @integrationComposeConfig down }
}

# Synopsis: Prevent subsequent task execution in cases where tests have failed
task ThrowOnTestFailure {
    assert(-not(error IntegrationTest)) "Testing quality gate failed"
}

# Synopsis: Remove version specific docker image tags so that the server does not keep docker images for previous builds
task UntagVersion -After Publish {
    $versionRepoTags | ForEach-Object {
        exec { docker image rm $_ }
    }
}

# Synopsis: Pull the latest base images used by our containers
task UpdateBaseImages -Before Build -If ($SkipPull -eq $false) {
    foreach ($baseImage in @($env:BUILD_BASE_IMAGE, $env:RUNTIME_BASE_IMAGE, $env:DB_IMAGE_TAG)) {
        exec { docker pull $baseImage }
    }
}

# Synopsis: Calls docker-compose up to start the 'latest' (ie current production version) of app. Once up, opens a browser to the SPA home page
task Up {
    ComposeUp -Name $imageName
}

# Synopsis: Calls docker-compose up to start a dev build of app. Once up, opens a browser to the SPA home page
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