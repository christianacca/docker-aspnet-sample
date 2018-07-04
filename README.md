# ASP.NET MVC Docker Sample

This [sample](Dockerfile) demonstrates how to use ASP.NET MVC and Docker together.

The sample builds the application in a container based on a custom version of [.NET Framework SDK Docker image](https://hub.docker.com/r/christianacca/dotnet-framework/.

This sample requires [Docker 17.06](https://docs.docker.com/release-notes/docker-ce) or later of the [Docker client](https://store.docker.com/editions/community/docker-ce-desktop-windows).

## Try a pre-built ASP.NET Docker Image

You can quickly run a container with a pre-built [sample ASP.NET Docker image](https://hub.docker.com/r/christianacca/aspnetapp-sample/).

In a powershell prompt type the following [Docker](https://www.docker.com/products/docker) command:

```powershell
.\build.ps1 Up
```

The above command ultimately:
* uses `docker-compose up` to start the web app and it's associated database running in containers
* open a browser window (chrome) and navigates to the home page of the web app

## Getting the sample

The easiest way to get the sample is by cloning the samples repository with [git](https://git-scm.com/downloads), using the following instructions:

```console
git clone https://github.com/christianacca/docker-aspnet-sample.git
```

## Build and run the sample with Docker

You can build and run the sample in Docker using the following commands. The instructions assume that you are in the root of the repository.

```powershell
.\build.ps1 Build, UpDev
```