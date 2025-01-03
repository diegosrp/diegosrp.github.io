---
title: Kicking off a series about the terraform-azurerm-caf-enterprise-scale module
date: 2024-12-01 22:00 +1300
categories: [Azure CAF, terraform-azurerm-caf-enterprise-scale]
tags: [cloud, microsoft, azure, hashicorp, terraform, iac, automation, infrastructure, security, governance, core, caf, management, policy, enterprise-scale]
image:
  path: https://stpersonalblog24.blob.core.windows.net/titles/kick_off_caf.png
  # path: /assets/img/titles/caf_overview.png
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

<a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale" target="_blank">https://github.com/Azure/terraform-azurerm-caf-enterprise-scale</a> is a set of Terraform modules developed by Microsoft to aid in the deployment and management of resources in Azure following the best practices of <a href="https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/" target="_blank">Microsoft's Cloud Adoption Framework (CAF)</a>.

<br>

## It consists of the following submodules:
### <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources" target="_blank">Core resources</a>

- Create the Management Group resource hierarchy <br>
- Assign Subscriptions to Management Groups <br>
- Create custom Policy Assignments, Policy Definitions and Policy Set Definitions (Initiatives) <br>
- Role assignments, Role definitions

---

### <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources" target="_blank">Management Resources</a>

- Create a central Log Analytics workspace and Automation Account <br>
- Link Log Analytics workspace to the Automation Account <br>
- Deploy recommended Log Analytics Solutions <br>
- Enable Microsoft Defender for Cloud <br>
- Enable Sentinel

---

### <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources" target="_blank">Connectivity Resources</a> 

- Create a centralized hub network: Traditional Azure networking topology (hub and spoke), Virtual WAN network topology (Microsoft-managed) <br>
- Secure network design: Azure Firewall, DDoS Network Protection <br>
- Hybrid connectivity: Azure Virtual Network Gateway, Azure ExpressRoute Gateway <br>
- Centrally managed DNS zones <br>

---

### <a href="https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources" target="_blank">Identity Resources</a> 

- Secure the identity subscription using Azure Policy <br>
- Create custom Role Assignments and Role Definitions

---

## Conclusion
*I really like this module because it is highly flexible. You don't need to implement all the submodules or every resource within each submodule; you can customize it to suit the needs of your environment.*