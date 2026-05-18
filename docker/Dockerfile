# ============================================
# Multi-stage Dockerfile
# Stage 1 - Build
# Stage 2 - Runtime (smaller final image)
# ============================================

# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies first (better caching)
COPY AzurePortfolioAPI/AzurePortfolioAPI.csproj AzurePortfolioAPI/
RUN dotnet restore AzurePortfolioAPI/AzurePortfolioAPI.csproj

# Copy everything else and build
COPY AzurePortfolioAPI/ AzurePortfolioAPI/
WORKDIR /src/AzurePortfolioAPI
RUN dotnet publish -c Release -o /app/publish

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files from build stage
COPY --from=build /app/publish .

# Expose port
EXPOSE 8080

# Set environment variable
ENV ASPNETCORE_URLS=http://+:8080

# Start the app
ENTRYPOINT ["dotnet", "AzurePortfolioAPI.dll"]