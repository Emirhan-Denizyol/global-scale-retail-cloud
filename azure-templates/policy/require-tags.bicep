@description('Required tag names.')
param requiredTags array = [
  'Environment'
  'Owner'
  'CostCenter'
]

resource requireTagsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'require-global-retail-tags'
  properties: {
    displayName: 'Require Global Retail mandatory tags'
    description: 'Requires Environment, Owner, and CostCenter tags on resources.'
    mode: 'Indexed'
    policyRule: {
      if: {
        anyOf: [
          {
            field: '[concat(''tags['', parameters(''requiredTags'')[0], '']'')]'
            exists: 'false'
          }
          {
            field: '[concat(''tags['', parameters(''requiredTags'')[1], '']'')]'
            exists: 'false'
          }
          {
            field: '[concat(''tags['', parameters(''requiredTags'')[2], '']'')]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
    parameters: {
      requiredTags: {
        type: 'Array'
        metadata: {
          displayName: 'Required tags'
        }
      }
    }
  }
}

output policyDefinitionId string = requireTagsPolicy.id
