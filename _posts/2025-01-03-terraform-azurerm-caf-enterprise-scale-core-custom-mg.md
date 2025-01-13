---
title: Adding the custom_landing_zones parameter
date: 2025-01-03 12:15 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

### What does the **custom_landing_zones** parameter do?  
The **custom_landing_zones** parameter is used to deploy additional Management Groups within the core Management Group hierarchy.

![](https://stpersonalblog24.blob.core.windows.net/posts/custom_landing_zones_main.png)

### Why customize Management Groups when there’s already a structure based on best practices?
 Because not all businesses are the same. Sometimes, the default structure doesn’t align with specific requirements, or unique needs arise that demand adjustments. Luckily, the module allows these customizations seamlessly.

Planning the hierarchy carefully is essential to maintain clarity and coherence in your organization.

## Example
How you would add a simple Management Group called **CUSTOM** under the *mg-example-landing-zones* Management Group, where root_id = *"mg-example"* and using the *default_empty* archetype definition.

![](https://stpersonalblog24.blob.core.windows.net/posts/custom_landing_zones.png)

**Key Parameters:**<br>
- `display_name` is the name assigned to the Management Group. <br>
- `parent_management_group_id` is the name of the parent Management Group and must be a valid Management Group ID. <br>
- `subscription_ids` is an object containing a list of Subscription IDs to assign to the current Management Group. <br>
- `archetype_config` is used to configure the configuration applied to each Management Group. This object must contain valid entries for the archetype_id parameters, and access_control attributes. <br>

<br>

Management Groups after the custom_landing_zones parameter is added:
![](https://stpersonalblog24.blob.core.windows.net/posts/custom_landing_zones_mg_structure.png)

🔗 Check out the repository and stay tuned for future updates: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.2/core" target="_blank">https://github.com/diegosrp/azure-caf/core/adding_custom_management_group</a>

<br>

---
**Adjustments in the repository**,
several changes have been made in this version of the repository that do not directly affect the `custom_landing_zones` parameter itself.

These changes include the separation of the **backend** and **provider** configurations into dedicated *files*, following HashiCorp's best practices.

Additionally, I have set the following parameters in the code:
- **`deploy_identity_resources = false`**
- **`deploy_connectivity_resources = false`**
- **`deploy_management_resources = false`**

By default, these parameters are already set to **false**, but they were added to the code for visibility, allowing readers to easily identify them. 

##### Parameter Details:
- `deploy_identity_resources`  
  Description: If set to `true`, this will enable the "Identity" landing zone settings.  
  Type: `bool`  
  Default: `false`

- `deploy_management_resources`
  Description: If set to `true`, this will enable the "Management" landing zone settings and add "Management" resources into the current Subscription context.  
  Type: `bool`  
  Default: `false`  

- `deploy_connectivity_resources` 
  Description: If set to `true`, this will enable the "Connectivity" landing zone settings and add "Connectivity" resources into the current Subscription context.  
  Type: `bool`  
  Default: `false`

  **These resources are not being configured at this time. When we proceed with their configuration, it will be done in a separate repository and state to reduce the blast radius, as mentioned at the beginning of the series of episodes on using CAF (Cloud Adoption Framework).**

<br>

Additionally, the following parameters have been added:
- **`disable_base_module_tags = true`**
- **`disable_telemetry = true`**

##### Parameter Details:
  - `disable_base_module_tags`  
    Description: If set to `true`, this will remove the base module tags applied to all resources deployed by the module that support tags.  
    Type: `bool`  
    Default: `false`


  - `disable_telemetry`  
    Description: If set to `true`, this will disable telemetry for the module. See [Telemetry Documentation](https://aka.ms/alz-terraform-module-telemetry).  
    Type: `bool`  
    Default: `false`

Lastly, changes have been made regarding on settings.core.tf **subscriptions** for the **Management Group**, **Connectivity**, and **Management** resources, but these depend on your specific environment.