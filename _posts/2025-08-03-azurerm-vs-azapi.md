---
title: AzureRM vs AzAPI
date: 2025-08-03 22:00 +1300
categories: [Concepts & Tips, HashiCorp Terraform]
tags: [hashicorp, terraform, iac, automation, infrastructure]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

### AzureRM

Is the traditional and most widely used Terraform provider for creating and managing resources in Microsoft Azure. It offers native support for a wide range of services with specific blocks tailored to each resource type.

**Advantages:**
- Easy to use and understand  
- Comprehensive documentation with examples  
- Automatic validation of fields and structure during plan and apply stages

**Disadvantages:**
- New Azure resources or features may not be immediately available, requiring provider updates  
- May be limited in advanced or edge-case configurations

<br> **Example** <br>

```hcl
# Create a Managed Identity using AzureRM
resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "id-example-azurerm"
}
```
<br>

---

### AzAPI

Is a newer provider gaining popularity due to its ability to interact directly with the Azure REST API. It allows you to create and manage **any** resource exposed through the API, even if it's not yet supported in AzureRM.

**Advantages:**
- High flexibility and full control over resources  
- Immediate access to new or preview features  
- Supports advanced and custom configurations

**Disadvantages:**
- Requires deeper technical knowledge of the Azure API  
- No automatic validation, which may lead to runtime errors  
- More complex structure and syntax, requiring careful attention

<br> **Example**

```hcl
# Default Management Group created with azapi
resource "azapi_resource" "default_mg" {
  type = "Microsoft.Management/managementGroups/settings@2021-04-01"
  parent_id = "/providers/Microsoft.Management/managementGroups/mg-root"

  name = "custom"
  body = jsonencode({
    properties = {
      defaultManagementGroup = "example"
      requireAuthorizationForGroupCreation = true
    }
  })
}
```

<br>

---

### Using both providers together

One interesting and powerful approach is to use both providers in the same Terraform project. This hybrid setup allows you to rely on `azurerm` for stable, well-documented resources, while leveraging `azapi` for advanced, custom, or preview features. You can even reference resources created by one provider within the other.
<br>
<br>
**Example**

```hcl
# Resource Group created with azurerm
resource "azurerm_resource_group" "example" {
  name     = "rg-example-azurerm"
  location = "Australia East"
}

# Application Security Group created with azapi, referencing the azurerm resource group
resource "azapi_resource" "asg" {
  type      = "Microsoft.Network/applicationSecurityGroups@2023-05-01"
  parent_id = azurerm_resource_group.example.id
  location  = azurerm_resource_group.example.location

  name      = "asg-example-azapi"

  body = {
    properties = {}
  }
}
```

When inspecting the terraform state, you will see that both provider blocks are present.
![](/assets/img/posts/azurerm_vs_azapi_tfstate.png){: .left }

<br><br><br>


You can also explore the official [Microsoft documentation](https://learn.microsoft.com/en-us/azure/templates/#terraform-azapi-provider) for detailed information about available APIs and resource definitions used with the AzAPI provider.  <br><br>

---

**HashiCorp has published an article comparing the two providers, highlighting the differences and when to use each one. 
<br> It's definitely worth reading:** [AzAPI vs Azurerm – Enhancing Azure Deployments](https://www.hashicorp.com/en/blog/enhancing-azure-deployments-with-azurerm-and-azapi-terraform-providers)