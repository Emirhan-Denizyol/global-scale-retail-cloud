targetScope = 'subscription'

@description('Custom policy definition name.')
param policyDefinitionName string = 'require-global-retail-tags'

@description('Policy assignment name.')
param policyAssignmentName string = 'assign-global-retail-required-tags'

resource requireTagsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyDefinitionName
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Require mandatory Global Retail tags'
    description: 'Requires Environment, Owner, and CostCenter tags on Azure resources.'
    metadata: {
      category: 'Tags'
    }
    parameters: {}
    policyRule: {
      if: {
        anyOf: [
          {
            field: 'tags[Environment]'
            exists: 'false'
          }
          {
            field: 'tags[Owner]'
            exists: 'false'
          }
          {
            field: 'tags[CostCenter]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource requireTagsAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignmentName
  properties: {
    displayName: 'Assign mandatory Global Retail tag policy'
    description: 'Assigns the mandatory tag policy at subscription scope.'
    policyDefinitionId: requireTagsPolicy.id
    enforcementMode: 'Default'
    nonComplianceMessages: [
      {
        message: 'Resources must include Environment, Owner, and CostCenter tags.'
      }
    ]
  }
}

output policyDefinitionId string = requireTagsPolicy.id
output policyAssignmentId string = requireTagsAssignment.id
