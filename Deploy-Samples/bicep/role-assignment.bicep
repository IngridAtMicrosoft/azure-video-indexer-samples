param principalId string
param eventHubNamespace string

@description('Contributor role definition ID')
var contributorRoleDefinitionId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

@description('Event Hub Data Contributor role definition ID')
var eventHubDataContributorRoleDefinitionId = 'f526a384-b230-433a-b45c-95f59c4a2dec'

resource eventHubNs 'Microsoft.EventHub/namespaces@2023-01-01-preview' existing = {
  name: eventHubNamespace
}

@description('Grant Subscription Contributor role to the service principal - to call Get Arm Access Token')
resource subscription_role 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, principalId, 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contributorRoleDefinitionId)
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource eventHubRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(eventHubNs.id, principalId, eventHubDataContributorRoleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', eventHubDataContributorRoleDefinitionId)
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
  scope: eventHubNs
}
