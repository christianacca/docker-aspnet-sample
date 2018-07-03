# escape=`
ARG RUNTIME_BASE_IMAGE=microsoft/aspnet:latest
FROM aspnetapp-sample:build AS build

ARG VS_CONFIG=Release

RUN msbuild PartsUnlimited.Web/PartsUnlimited.Web.csproj /p:Configuration=%VS_CONFIG% /p:DeployOnBuild=true /p:PublishProfile=DeployLocally

FROM ${RUNTIME_BASE_IMAGE} AS runtime
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /inetpub/wwwroot

HEALTHCHECK --interval=10s --start-period=90s `
 CMD powershell -command `
    try { `
     $response = iwr http://localhost/ -UseBasicParsing; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }

ENTRYPOINT [ "powershell", "C:/scripts/bootstrap.ps1" ]
COPY --from=build /src/PartsUnlimited.Web/docker/ C:/scripts/
COPY --from=build /src/PartsUnlimited.Web/bin/Release/Publish/ ./