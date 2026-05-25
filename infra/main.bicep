// ============================================
// Project 2 - Container Registry + Container Apps
// ============================================

targetScope = 'subscription'

@description('Environment name')
@allowed(['dev', 'prod'])
param environment string = 'dev'

@description('Azure region')
param location string = 'eastus'

@description('Project name')
param projectName string = 'portfolioapi'

var resourceGroupName = 'rg-${projectName}-${environment}'
var tags = {
  Environment: environment
  Project: projectName
  ManagedBy: 'Bicep'
  CreatedBy: 'AzureDevOps'
}

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Container Registry
module acr './modules/containerregistry.bicep' = {
  name: 'acrDeployment'
  scope: rg
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: tags
  }
}



output resourceGroupName string = rg.name
output acrLoginServer string = acr.outputs.acrLoginServer
output acrName string = acr.outputs.acrName