#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["scaler/Scaler.csproj", "."]
RUN dotnet restore "Scaler.csproj"
COPY scaler .
RUN dotnet build "Scaler.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Scaler.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN groupadd --gid 5000 scaleruser && useradd --home-dir /home/scaleruser --create-home --uid 5000 --gid 5000 --shell /bin/sh --skel /dev/null scaleruser
USER scaleruser

ENV ASPNETCORE_URLS http://+:1080
EXPOSE 1080

ENTRYPOINT ["dotnet", "Scaler.dll"]
