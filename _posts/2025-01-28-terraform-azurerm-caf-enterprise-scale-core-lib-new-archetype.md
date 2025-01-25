---
title: Creating a new archetype_id
date: 2025-01-28 00:15 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

As we shape our environment and address our needs, imagine that the `mg-example-custom` we created does not yet have defined policies and is only inheriting policies from the Management Groups above. Now, we want to customize this setup to meet specific requirements.

## Creating an archetype_id for our mg-example-custom
I created the file `archetype_definition_mg_example_custom.json` in the `lib/archetype_definitions` folder. Inside the file structure, I added the policy name under the `policy_assignments` array, as shown in the example below:

```json
{
  "custom": {
    "policy_assignments": [
      "Deny-MgmtPorts-Internet"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```

We will also add a budget policy. Since the definition of this policy is created by the module and is not associated with any Management Group, we need to create the assignment file.

To achieve this, I create a file named `policy_assignment_mg_custom_deploy_budget.json` in the `lib/policy_assignments` folder with this content:
```json
{
  "name": "Budget",
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "properties": {
      "description": "Deploy a default budget on all subscriptions under the assigned scope",
      "displayName": "Deploy a default budget on all subscriptions under the assigned scope",
      "notScopes": [],
      "parameters": {},
      "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/Deploy-Budget",
      "nonComplianceMessages": [],
      "scope": "${current_scope_resource_id}",
      "enforcementMode": null
  },
  "location": "${default_location}",
  "identity": {
      "type": "SystemAssigned"
  }
}
```

So I updated the assignments in the `archetype_definition_mg_example_custom.json` file:

```json
{
  "custom": {
    "policy_assignments": [
      "Deny-MgmtPorts-Internet",
      "Budget"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```


So now we need to update the `archetype_id` of the Management Group we created in **caf_configure_custom_landing_zones**.
![](https://stpersonalblog24.blob.core.windows.net/posts/new_archetype.png)
Notice that the name of the `archetype_id` I added is the same as the `archetype_definition_mg_example_custom.json` file.

<br>
**With this, we are almost finished with the core submodule. In the next post, I will show how to modify a parameter of an associated policy, and then we will begin working on the management submodule. Stay tuned!**

<br>
🔗 Check out the changes in the repository: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.5/core" target="_blank">https://github.com/diegosrp/azure-caf/core/new_archetype</a>
