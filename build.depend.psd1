@{ 
    PSDependOptions  = @{ 
        Target    = '$DependencyPath/_build-cache/'
        AddToPath = $true
    }
    BuildHelpers     = '1.1.0'
    DockerHelpers    = '0.1.3'
    InvokeBuild      = '5.4.1'
    NuGet = @{
        DependencyType = 'FileDownload'
        Source = 'https://dist.nuget.org/win-x86-commandline/v4.6.2/nuget.exe'
    }
}