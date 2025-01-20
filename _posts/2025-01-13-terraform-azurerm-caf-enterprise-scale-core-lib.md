---
title: Getting started with the library_path parameter
date: 2025-01-13 00:15 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

### What does the **library_path** parameter do?  
The **library_path** parameter defines the location of a custom library folder for <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions" target="_blank">archetype</a>.

![](https://stpersonalblog24.blob.core.windows.net/posts/lib_parameter.png)

### Why use a custom library?
The module enables the creation of a resource management structure in Azure, aligned with the best practices of the Cloud Adoption Framework. However, the default structure may not fully address the unique requirements of every organization. To address this, the module provides the flexibility to add, remove, or update policies and roles, making it a highly valuable feature.

### How does it work?  
By default, the module includes a set of predefined policies and roles, located in the `\modules\archetypes\lib\` directory.  

To customize this, you need to create a `lib` folder and follow specific naming conventions and file extensions. Both international and custom libraries are used to store ARM-based templates for Policy Assignments, Policy Definitions, Policy Set Definitions (Initiatives), and Role Definitions. Role Assignments are an exception, as they are defined as part of the `archetype_config` instead.

To use a custom library, create a folder in your module's root (e.g., `/lib`) and reference it using the `library_path` variable (e.g., `library_path = "${path.root}/lib"`). Save your custom templates in the library folder, and as long as they are valid templates for the resource type and follow the naming conventions outlined below, the module will automatically import and use them:

| Resource Type               | File Name Pattern                                                          |
|-----------------------------|----------------------------------------------------------------------------|
| Archetype Definitions       | **/archetype_definition_*.{json,yml,yaml,json.tftpl,yml.tftpl,yaml.tftpl}  |
| Policy Assignments          | **/policy_assignment_*.{json,yml,yaml,json.tftpl,yml.tftpl,yaml.tftpl}     |
| Policy Definitions          | **/policy_definition_*.{json,yml,yaml,json.tftpl,yml.tftpl,yaml.tftpl}     | 
| Policy Set Definitions      | **/policy_set_definition_*.{json,yml,yaml,json.tftpl,yml.tftpl,yaml.tftpl} |
| Role Definitions            | **/role_definition_*.{json,yml,yaml,json.tftpl,yml.tftpl,yaml.tftpl}       |

> The module also supports YAML files for these templates, as they follow the ARM schema.
{: .prompt-info }

It’s important to note that although the module creates policies, definitions, and assignments, not all of them are automatically associated. You will need to manually assign and configure them as per your specific needs.

<br>

You can access the <a href="https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Policies" target="_blank">ALZ Policies</a> link to view the definitions, policies, roles, and assignments that the module creates.




