---
title: How to organize Subscriptions in Management Groups
date: 2024-12-26 00:02 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

### What is a *Management Group*?  
A *Management Group* in Azure is a hierarchical structure designed to centralize and streamline the organization and management of multiple *subscriptions*. Acting as a container for *subscriptions*, it simplifies the application of policies, access controls, and configurations across all associated *subscriptions*.  

One of the key benefits of a *management group* is the automatic inheritance of settings and policies. This means that any configuration applied to a *management group* cascades down to all the *subscriptions* within it, ensuring consistency and reducing administrative overhead.  

You can structure *management groups* to align with your specific needs, such as by environment (e.g., development, staging, production), project, resource type, or other logical groupings.

---

Thinking about this, in the terraform-azurerm-caf-enterprise-scale module, we have the parameter:

**subscription_id_overrides** 
```sh
Description: If specified, this will be used to assign subscription_ids to the default Enterprise-scale Management Groups.
Type: map(list(string))
Default: {}
```

In this parameter, we can associate *subscriptions* with specific *management groups* in your environment. 

I will show you how to configure each *subscription* in the corresponding *management groups*, enabling more efficient organization and centralized governance according to your organization's structure.


**My current management group structure**
![](https://stpersonalblog24.blob.core.windows.net/posts/sub_overrides_mg_before.png)

<br>

## Adding the subscription_id_overrides parameter 
Inside the `main.tf` file 
![](https://stpersonalblog24.blob.core.windows.net/posts/sub_overrides_main.png)

<br>

## Adding the configuration for each management group
The configurations will be provided in `settings.core.tf` (the 'default' file used for configuring the core submodule). This way, anyone working with the module and already familiar with it will know exactly where to look for the submodule configurations. 

I will assign subscriptions to the following management groups: `Landing Zones` and `Platform`.
![](https://stpersonalblog24.blob.core.windows.net/posts/sub_overrides_settings_core.png)

<br>

### Updated Structure
![](https://stpersonalblog24.blob.core.windows.net/posts/sub_overrides_mg_after.png)




<br>
🔗 Check out the repository and stay tuned for future updates: <a href="https://github.com/diegosrp/azure-caf/tree/v1.0.1/core" target="_blank">https://github.com/diegosrp/azure-caf/core/subscription_id_overrides</a>