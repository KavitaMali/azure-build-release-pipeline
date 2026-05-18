targetScope = 'resourceGroup'

param location string
param projectName string
param environment string
param tags object
param acrLoginServer string
param acrName string

var containerAppEnvName = 'cae-${projectName}-${environment}'
var containerAppName = 'ca-${projectName}-${environment}'

// Container Apps Environment
resource containerAppEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: containerAppEnvName
  location: location
  tags: tags
  properties: {
    zoneRedundant: false
  }
}

// Reference existing ACR for credentials
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

// Container App
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  tags: tags
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
        transport: 'http'
      }
      registries: [
        {
          server: acrLoginServer
          username: acr.listCredentials().username
          passwordSecretRef: 'acr-password'
        }
      ]
      secrets: [
        {
          name: 'acr-password'
          value: acr.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: '${acrLoginServer}/${projectName}:latest'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: environment
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0    // Scales to zero when not in use = free!
        maxReplicas: 1
      }
    }
  }
}

output containerAppUrl string = 'https://${containerApp.properties.configuration.ingress.fqdn}'