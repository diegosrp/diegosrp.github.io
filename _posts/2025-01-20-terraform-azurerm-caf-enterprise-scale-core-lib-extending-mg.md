---
title: Extending a Management Group - Managing Policies and Initiatives
date: 2025-01-20 00:15 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

In the previous post, we explained how the `library_path` parameter works and outlined the requirements for customizing policies and initiatives.
Now, it’s time to put that knowledge into practice.

> For all the examples in this post, we will work based on `mg-example-management`.
{: .prompt-warning }

![](https://stpersonalblog24.blob.core.windows.net/posts/lib_parameter.png)

<br>

## How to Associate a Policy created by the module with a different Management Group?
In this example, we will add the policy `"Deny-Subnet-Without-Nsg"`, to the management group `mg-example-management`, which was created by the module.  

To achieve this, I created the file `archetype_extension_es_management.json` in the `lib/archetype_definitions` folder. Inside the file structure, I added the policy name under the `policy_assignments` array, as shown in the example below:

```json
{
  "extend_es_management": {
    "policy_assignments": [
      "Deny-Subnet-Without-Nsg",
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {}
  }
}
```

> The policy already exists in `mg-example-identity`, and there is a default assignment file. Therefore, we only need to add the policy name to the archetype.<br><br>
>How do I know policy name to use? I accessed the <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/modules/archetypes/lib/policy_definitions/policy_definition_es_deny_subnet_without_nsg.json" target="_blank">policy definition file</a> created by the module and grab the `name`. <br><br>
> To know the names of the default archetypes for management groups, you can check the names at the beginning of the archetype files in `modules/archetypes/lib/archetype_definitions`, where the defaults usually start with `es_NAME`. We add `extend_` before because we are extending the existing management group.
{: .prompt-info }

## Is it possible to associate an existing built-in Azure Policy/Initiative using the module? 
Yes, it is possible. In this example, we will associate the **ISO 27001:2013** initiative to `mg-example-management`.

To achieve this, I create a file named `policy_assignment_es_management_iso27001.json` in the `lib/policy_assignments` folder with this content:

```json
{
  "name": "ISO-27001",
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "properties": {
      "description": "The International Organization for Standardization (ISO) 27001 standard provides requirements for establishing, implementing, maintaining, and continuously improving an Information Security Management System (ISMS). These policies address a subset of ISO 27001:2013 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/iso27001-init",
      "displayName": "ISO 27001:2013",
      "notScopes": [],
      "parameters": {
      },
      "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2",
      "nonComplianceMessages": [
        {
          "message": "ISO 27001 {enforcementMode} be enforced"
        }
      ],
      "scope": "${current_scope_resource_id}",
      "enforcementMode": null
  },
  "location": "${default_location}",
  "identity": {
      "type": "SystemAssigned"
  }
}
```

I added the initiative to the `policy_assignments` array in `archetype_extension_es_management.json`, as its definition already exists since it's built-in. Therefore, I don't need to create a definition and add it to the archetype in the *policy_set_definitions*.

```json
{
  "extend_es_management": {
    "policy_assignments": [
      "Deny-Subnet-Without-Nsg",
      "ISO-27001"
    ],
    "policy_definitions": [],
    "policy_set_definitions": [],
    "role_definitions": [],
    "archetype_config": {}
  }
}
```

## How do I create a custom Policy?
To achieve this, I created a file named `policy_definition_custom_restrict_cognitive_services_types.json` in the `lib/policy_definitions` folder as shown in the example below:  

```json
{
  "name": "Restrict-Cognitive-Services-Types",
  "type": "Microsoft.Authorization/policyDefinitions",
  "properties": {
    "displayName": "Restrict Cognitive Services Types",
    "description": "Enforces the allowed deployment types for Microsoft Cognitive Services accounts. Deployments with unapproved SKUs will be denied.",
    "metadata": {
      "category": "Cognitive Services",
      "version": "1.0.0"
    },
    "mode": "All",
    "parameters": {
      "allowedSkus": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed Deployment Types",
          "description": "Select the allowed Deployment Types for deployment"
        },
        "allowedValues": [
          "Standard",
          "Provisioned-Managed",
          "GlobalStandard"
        ],
        "defaultValue": [
          "Standard",
          "GlobalStandard"
        ]
      },
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect for the others",
          "description": "Enable or disable the enforcement of the policy"
        },
        "allowedValues": [
          "AuditIfNotExists",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Deny"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.CognitiveServices/accounts/deployments"
          },
          {
            "field": "Microsoft.CognitiveServices/accounts/deployments/sku.name",
            "notIn": "[parameters('allowedSkus')]"
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```

After creating the file, I Added the initiative to the `policy_definitions` array in `archetype_extension_es_management.json`:

```json
{
  "extend_es_management": {
      "policy_assignments": [
        "Deny-Subnet-Without-Nsg",,
        "ISO-27001"
      ],
      "policy_definitions": [
        "Restrict-Cognitive-Services-Types"
      ],
      "policy_set_definitions": [],
      "role_definitions": [],
      "archetype_config": {}
  }
}
```

> In this case, I am only creating the policy, but I am not associating it with any management group. If I were to associate it, I would need the assignment file and place it in the archetype structure under `policy_assignments`. However, it has not been associated because we will use it within the initiative instead.
{: .prompt-info }

## How do I create a custom Initiative?
To achieve this, I created a file named `policy_set_definition_custom_example_initiative.json` in the `lib/policy_set_definitions` folder as shown in the example below:  

```json
{
  "name": "Example-Initiative",
  "type": "Microsoft.Authorization/policySetDefinitions",
  "properties": {
    "displayName": "Example Initiative",
    "policyType": "Custom",
    "description": "Just an example initiative.",
    "metadata": {
      "category": "General"
    },
    "version": "1.0.0",
    "parameters": {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "The name of the tag to enforce."
        },
        "defaultValue": "business-owner"
      }
    },
    "policyDefinitions": [
      {
        "policyDefinitionReferenceId": "Provisioned-Managed deployment type is not allowed",
        "policyDefinitionId": "${root_scope_resource_id}-management/providers/Microsoft.Authorization/policyDefinitions/Restrict-Cognitive-Services-Types",
        "definitionVersion": "1.*.*",
        "effectiveDefinitionVersion": "1.0.0",
        "parameters": {}
      },
      {
        "policyDefinitionReferenceId": "Require a tag on resource group: business-owner",
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025",
        "definitionVersion": "1.*.*",
        "effectiveDefinitionVersion": "1.0.0",
        "parameters": {
          "tagName": {
            "value": "[parameters('tagName')]"
          }
        }
      }
    ],
    "policyDefinitionGroups": []
  }
}
```

> In this initiative example, I am creating it with two policies: one custom policy I created in the previous example and one built-in policy. Since the built-in policy already exists, I don't need to create the definition file for it; I just add its ID.
{: .prompt-info }

After creating the file, I Added the initiative to the `policy_set_definitions` array in `archetype_extension_es_management.json`:

```json
{
  "extend_es_management": {
      "policy_assignments": [
        "Deny-Subnet-Without-Nsg",,
        "ISO-27001"
      ],
      "policy_definitions": [
        "Restrict-Cognitive-Services-Types"
      ],
      "policy_set_definitions": [
        "Example-Initiative"
      ],
      "role_definitions": [],
      "archetype_config": {}
  }
}
```

## How do I associate the custom Initiative?
To associate the custom initiative, I created a file named `policy_assignment_es_management_example_initiative.json` in the `lib/policy_assignments` folder as shown in the example below:  

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2019-09-01",
  "name": "Ex-Init-Assign",
  "location": "${default_location}",
  "identity": {
    "type": "None"
  },
  "properties": {
    "description": "Just an example initiative.",
    "displayName": "Example Initiative Assignment",
    "policyDefinitionId": "${root_scope_resource_id}-management/providers/Microsoft.Authorization/policySetDefinitions/Example-Initiative",
    "nonComplianceMessages": [
      {
        "message": "Resources under this scope must comply with the Example Initiative."
      }
    ],
    "parameters": {
      "tagName": {
        "value": "business-owner"
      }
    },
    "notScopes": [],
    "scope": "${current_scope_resource_id}",
    "enforcementMode": null
  }
}
```

After creating the file, I Added the initiative to the `policy_assignments` array in `archetype_extension_es_management.json`:

```json
{
  "extend_es_management": {
      "policy_assignments": [
        "Deny-Subnet-Without-Nsg",,
        "ISO-27001",
        "Ex-Init-Assign"
      ],
      "policy_definitions": [
        "Restrict-Cognitive-Services-Types"
      ],
      "policy_set_definitions": [
        "Example-Initiative"
      ],
      "role_definitions": [],
      "archetype_config": {}
  }
}
```

In summary, you need to determine if the policy/initiative you want already exists, if it is being created by the module, and then associate the files, whether they are definitions or assignments.

<br>
🔗 Check out the changes in the repository: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.3/core" target="_blank">https://github.com/diegosrp/azure-caf/core/extending_a_management_group</a>

<br>

You can also check the documentation through the repository's <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Assign-a-Built-in-Policy#libpolicy_assignmentspolicy_assignment_not_allowed_resource_typesjson" target="_blank">wiki</a>.

We can review the definitions and associations of the policies/initiatives created by the module within each  
<a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/main/modules/archetypes/lib" target="_blank">Module Library</a> folder

<a href="https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure" target="_blank">Azure Policy assignment structure</a>
