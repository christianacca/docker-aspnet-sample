# ASP.NET MVC Docker Sample

This sample demonstrates how to use ASP.NET MVC and Docker together.

Enhancements over the [official sample](https://github.com/Microsoft/dotnet-framework-docker/blob/master/samples/aspnetapp/Dockerfile):
* *publishes* a *pre-compiled* web application
* has a production ready CI build script

This sample requires [Docker 17.06](https://docs.docker.com/release-notes/docker-ce) or later of the [Docker client](https://store.docker.com/editions/community/docker-ce-desktop-windows).


## Try a pre-built ASP.NET Docker Image

You can quickly run a container with a pre-built [sample ASP.NET Docker image](https://hub.docker.com/r/christianacca/aspnetapp-sample/).

1. Download / browse to directory containing [docker-compose.yml](docker-compose.yml)
2. Open a powershell prompt in the directory containing the `docker-compose.yml`
3. In the same powershell prompt run: `docker-compose -p aspnet-sample up -d`

To browse to the home page of the web app now running in a container:
1. Get the IP address of the container `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' (docker ps -f name=aspnet-sample_web-app_1 -q)`
2. Open a browser and navigate to the IP address

To cleanup:

* `docker-compose -p aspnet-sample down`


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
The above command ultimately:
1. builds a new image `christianacca/aspnetapp-sample` from code in the `src/` directory
2. uses `docker-compose up` to start the web app and it's associated database inside containers
3. open a browser window (chrome) and navigates to the home page of the web app
