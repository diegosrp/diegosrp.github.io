---
title: Excluding Archetype Components - Initiatives, Policies, or Custom Roles
date: 2025-01-25 00:15 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

In some cases, we may have an initiative, policy, or custom role created by the module that doesn't meet our business needs, and we would like or need to remove it. For this, we have the flexibility to do so, just as we have the option to extend. Let's take a look at this next.

## What do I need to remove a policy assignment?
Pretend that I need to remove the policy assignment `"Configure Advanced Threat Protection to be enabled on open-source relational databases"` which is assigned to **mg-example**. How do I know the scope?
You can see in the portal the scope where the policy is applied, or within the module, you can check the <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/archetype_definitions/archetype_definition_es_root.tmpl.json" target="_blank">archetypes_es_root</a> and identify the policy.

### How should I remove it?
You can find the assignment file within the module `modules/archetypes/lib/archetype_definitions/policy_assignments` or look in the policy library <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/policy_assignments/policy_assignment_es_deploy_mdfc_ossdb.tmpl.json" target="_blank">policy_assignment_es_deploy_mdfc_ossdb.tmpl.json
</a> and get its name.

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2022-06-01",
  "name": "Deploy-MDFC-OssDb",
  "location": "${default_location}",
  "dependsOn": [],
  "identity": {
    "type": "SystemAssigned"
  },
  "properties": {
    "description": "Enable Advanced Threat Protection on your non-Basic tier open-source relational databases to detect anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases. See https://aka.ms/AzDforOpenSourceDBsDocu.",
    "displayName": "Configure Advanced Threat Protection to be enabled on open-source relational databases",
    "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/e77fc0b3-f7e9-4c58-bc13-cb753ed8e46e",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Advanced Threat Protection {enforcementMode} be enabled on open-source relational databases."
      }
    ],
    "parameters": {},
    "scope": "${current_scope_resource_id}",
    "notScopes": []
  }
}
```

Ok, now that I have the name, what’s next? The process will be similar to the extending a management group, but instead of using extension, you will use exclusion.

<br>
To achieve this, I created the file `archetype_exclusion_es_root.json` in the `lib/archetype_definitions` folder. Inside the file structure, I added the policy name under the `policy_assignments` array, as shown in the example below:


```json
{
  "exclude_es_root": {
    "policy_assignments": [
      "Deploy-MDFC-OssDb"
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
By doing this, I am removing the policy assignment from this scope.

So, looking at it from a broader perspective, any type of addition or exclusion, whether it’s an initiative, policy, or custom role, will be handled through the archetypes, whether by extending or excluding. This will always depend on the scope you want to associate with, as each one will have its own specific archetype.

For example, we added the ISO:27001 initiative, which includes the policy `Audit usage of custom RBAC roles`. The CAF creates some custom roles, but since I want to follow ISO standards, it doesn't make sense to keep these custom roles. Therefore, I will remove them by using the archetype from where they were created, as shown below:

```json
{
  "exclude_es_root": {
    "policy_assignments": [
      "Deploy-MDFC-OssDb"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [
      "Network-Subnet-Contributor",
      "Application-Owners",
      "Network-Management",
      "Security-Operations",
      "Subscription-Owner"
    ],
    "archetype_config": {
      "parameters": {},
      "access_control": {}
    }
  }
}
```
<br>
🔗 Check out the changes in the repository: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.4/core" target="_blank">https://github.com/diegosrp/azure-caf/core/archetype_exclusion</a>