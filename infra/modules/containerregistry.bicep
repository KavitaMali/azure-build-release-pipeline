targetScope = 'resourceGroup'

param location string
param projectName string
param environment string
param tags object

var acrName = 'acr${projectName}${environment}${substring(uniqueString(resourceGroup().id), 0, 6)}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: 'Basic'    // Cheapest tier ~$5/month but free account credit covers it
  }
  properties: {
    adminUserEnabled: true    // Needed for Container Apps to pull images
  }
}

output acrLoginServer string = acr.properties.loginServer
output acrName string = acr.name