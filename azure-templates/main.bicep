@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Project name used for resource naming.')
param projectName string = 'global-retail'

@description('Deployment environment tag.')
param environment string = 'Prod'

@description('Owner tag.')
param owner string = 'Master-Grad'

@description('Cost center tag.')
param costCenter string = '101'

@description('Allowed public IP address for SQL firewall access. Use your own public IP.')
param allowedPublicIp string

@secure()
@description('SQL administrator password.')
param sqlAdminPassword string

@description('SQL administrator username.')
param sqlAdminUser string = 'sqladminuser'

var commonTags = {
  Environment: environment
  Owner: owner
  CostCenter: costCenter
  Project: projectName
  ManagedBy: 'Bicep'
}

var vnetName = '${projectName}-${toLower(environment)}-vnet'
var nsgName = '${projectName}-${toLower(environment)}-nsg'
var sqlServerName = '${projectName}-${uniqueString(resourceGroup().id)}-sqlsrv'
var sqlDbName = '${projectName}-${toLower(environment)}-db'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: nsgName
  location: location
  tags: commonTags
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-From-Allowed-IP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: allowedPublicIp
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-SQL-From-Allowed-IP'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: allowedPublicIp
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: commonTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Frontend'
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: 'Backend'
        properties: {
          addressPrefix: '10.1.2.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: 'Database'
        properties: {
          addressPrefix: '10.1.3.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' = {
  name: sqlServerName
  location: location
  tags: commonTags
  properties: {
    administratorLogin: sqlAdminUser
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
    publicNetworkAccess: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

resource sqlFirewallAllowedIp 'Microsoft.Sql/servers/firewallRules@2023-08-01' = {
  name: 'Allow-Configured-Public-IP'
  parent: sqlServer
  properties: {
    startIpAddress: allowedPublicIp
    endIpAddress: allowedPublicIp
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01' = {
  name: sqlDbName
  parent: sqlServer
  location: location
  tags: commonTags
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    maxSizeBytes: 2147483648
  }
}

output vnetName string = vnet.name
output frontendSubnet string = 'Frontend'
output backendSubnet string = 'Backend'
output databaseSubnet string = 'Database'
output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sqlDatabase.name
output sqlFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName
