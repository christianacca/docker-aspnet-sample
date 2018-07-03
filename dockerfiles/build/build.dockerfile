ARG BUILD_BASE_IMAGE=christianacca/dotnet-framework:sdk
FROM ${BUILD_BASE_IMAGE}
SHELL ["cmd", "/S", "/C"]

ARG VS_CONFIG=Release

WORKDIR /src

# restore nuget as distinct layers
COPY PartsUnlimited.Tests/packages.config ./PartsUnlimited.Tests/
RUN nuget restore PartsUnlimited.Tests -SolutionDirectory .
COPY PartsUnlimited.Web/packages.config ./PartsUnlimited.Web/
RUN nuget restore PartsUnlimited.Web -SolutionDirectory .
COPY PartsUnlimited.Infrastructure/packages.config ./PartsUnlimited.Infrastructure/
RUN nuget restore PartsUnlimited.Infrastructure -SolutionDirectory .

# copy everything else and build and publish app
COPY . .
RUN msbuild /p:Configuration=%VS_CONFIG% /m
