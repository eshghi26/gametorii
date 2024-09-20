# Use the official ASP.NET Core runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5169

# Copy the pre-built app from Jenkins workspace
COPY ./publish/ .

# The entry point to run the app
ENTRYPOINT ["dotnet", "GameApi.dll"]
