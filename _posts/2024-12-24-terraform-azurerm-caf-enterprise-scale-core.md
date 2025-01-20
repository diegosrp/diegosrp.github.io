---
title: Introduction to the Core submodule
date: 2024-12-24 00:30 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

## Overview
The core capability of this module deploys the foundations of the conceptual architecture for Azure landing zones, with a focus on the central resource organization.

![](https://stpersonalblog24.blob.core.windows.net/posts/core_design.png)

### Resource types

| Resource | Azure resource type |  Terraform resource type |
|--|--|--
| Management groups | Microsoft.Management/managementGroups | `azurerm_management_group` |
| Management group subscriptions | Microsoft.Management/managementGroups/subscriptions | `azurerm_management_group` or <br> `azurerm_management_group_subscription_association` |
| Policy assignments | Microsoft.Authorization/policyAssignments | `azurerm_management_group_policy_assignment` |
| Policy definitions | Microsoft.Authorization/policyDefinitions | `azurerm_policy_definition` |
| Policy set definitions | Microsoft.Authorization/policySetDefinitions | `azurerm_policy_set_definition` |
| Role assignments | Microsoft.Authorization/roleAssignments | `azurerm_role_assignment` |
| Role definitions | Microsoft.Authorization/roleDefinitions | `azurerm_role_definition` |

<br>
The exact number of resources that the module creates depends on the module configuration. For a default configuration, you can expect the module to create approximately 388 resources.

> **NOTE:** None of these resources are deployed at the subscription scope, but Terraform still requires a subscription to establish an authenticated session with Azure. For more information on authenticating with Azure, refer to the <a href="https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure" target="_blank">`Azure Provider: Authenticating to Azure`</a> documentation.
{: .prompt-info }

<br>

---

### Management group structure
![](https://stpersonalblog24.blob.core.windows.net/posts/core_mg.png) 

### Role definitions, Initiative and policies files 
<a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/v6.2.0/modules/archetypes/lib/role_definitions" target="_blank">`role_definitions`</a>, <br><a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/v6.2.0/modules/archetypes/lib/policy_definitions" target="_blank">`policy_definitions`</a>, <br> <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/v6.2.0/modules/archetypes/lib/policy_set_definitions" target="_blank">`policy_set_definitions`</a>, <br> <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/tree/v6.2.0/modules/archetypes/lib/policy_assignments" target="_blank">`policy_assignments`</a>.

---

## Terraform versions
The module has been tested with `Terraform 1.7.0` and `AzureRM Provider 3.108`, as well as newer versions available at release. If any errors occur, it is recommended to upgrade to the latest AzureRM provider version.

---

## Core module permissions
The module is primarily designed to build your resource hierarchy, manage policies and set permissions. As such, you can think of this as being the primary point of governance for your deployment to Azure. By design, the Azure platform (not the module) will automatically assign Owner permissions to the creator of any Management Group. This permission will be inherited by all child resources, including Management Groups, Subscriptions, Resource Groups and Resources.

To get started with the module for deploying `core resources`, you only need access to a single Subscription (for the Azure RM Provider to authenticate with Azure). No specific permissions are needed unless your Tenant has been configured to Require permissions for creating new management groups. If enabled, the module requires the Microsoft.Management/managementGroups/write operation on the root management group to create new child management groups. This operation is included in the recommended roles listed below so doesn't require additional configuration.

You also need to consider permissions needed for Moving management groups and subscriptions into the Azure landing zone resource hierarchy, as summarized below:

**Management group write and Role Assignment write permissions on the child subscription or management group**  
  Built-in role: `Owner`

**Management group write access on the target parent management group**  
  Built-in roles: `Owner`, `Contributor`, `Management Group Contributor`

**Management group write access on the existing parent management group**  
  Built-in roles: `Owner`, `Contributor`, `Management Group Contributor`

<br>
All Subscriptions will inherit Owner permissions from the Management Group hierarchy for the identity used to run Terraform. As the requirement for Role Assignment write permissions effectively gives this identity permissions to assign any other permissions, the module do not recommend altering this configuration. In most cases, they advise running this module within a secure CI/CD pipeline and monitoring the Activity Log for suspicious activity (using suitable SIEM tooling) to mitigate the risks associated with high privileged identities.

---

### Reduce scope of access control
To enable access to newly created Subscriptions whilst maintaining a security boundary from other parts of your hierarchy, consider provisioning a dedicated Management Group under the Tenant Root Group and configuring this as the default Management Group. This Management Group should not be managed by this module, and should be configured with the required permissions for the identity deploying this module to access it. By granting Terraform access to this Management Group, Terraform will be able to on-board new Subscriptions into the Azure landing zone hierarchy without needing additional permissions on the Tenant Root Group.

---

### Brownfield deployments
For brownfield environments, you may also wish to manually move existing Subscriptions into a custom default Management Group (as above) to enable on-boarding into the module, but always check the impact this will have on any existing policy and access control settings.

---

<br>

## Let's start with the minimal configuration of the core submodule, where the following management group structure will be created.

`terraform.tf`
![](https://stpersonalblog24.blob.core.windows.net/posts/core_terraform.png)
> In this example, I will use a local backend and separate the submodules into individual states to minimize blast radius. However, I strongly recommend using a remote state for team collaboration and production environments.
{: .prompt-info }

> **What is Blast Radius?** <br>
 In cybersecurity, the blast radius refers to the extent of damage or impact that a security incident can cause within an organization. It represents the range of systems, data, and operations that can be affected when a vulnerability is exploited, a system is compromised, or a malicious actor gains unauthorized access. Essentially, it is the “scope of destruction” that an incident can inflict.
{: .prompt-warning }

<br>

`data.tf`
![](https://stpersonalblog24.blob.core.windows.net/posts/core_data.png)

<br>

`main.tf`
![](https://stpersonalblog24.blob.core.windows.net/posts/core_main.png)
> Remember that the module includes the submodules: core, management, connectivity, and identity. At this moment, we are starting with only the core submodule with the minimum possible configuration. Thus, I will repeat the `azurerm` provider for the other submodules.
{: .prompt-info }

<br>

`variables.tf`
![](https://stpersonalblog24.blob.core.windows.net/posts/core_variables.png)

<br>

`terraform.tfvars`
![](https://stpersonalblog24.blob.core.windows.net/posts/core_tfvars.png)

> Remember to **replace** the fields marked with `< >`.
{: .prompt-warning }


![](https://stpersonalblog24.blob.core.windows.net/posts/core_plan.png)

<br>
🔗 Check out the repository and stay tuned for future updates: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.0/core" target="_blank">https://github.com/diegosrp/azure-caf/core</a>