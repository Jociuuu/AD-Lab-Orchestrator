FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5096

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["src/LabOrchestrator.API/LabOrchestrator.API.csproj", "src/LabOrchestrator.API/"]
COPY ["src/LabOrchestrator.Core/LabOrchestrator.Core.csproj", "src/LabOrchestrator.Core/"]
RUN dotnet restore "src/LabOrchestrator.API/LabOrchestrator.API.csproj"
COPY . .
RUN dotnet build "src/LabOrchestrator.API/LabOrchestrator.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/LabOrchestrator.API/LabOrchestrator.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY scripts/ ./scripts/
ENTRYPOINT ["dotnet", "LabOrchestrator.API.dll"]