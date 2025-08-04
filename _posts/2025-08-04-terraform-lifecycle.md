---
title: Lifecycle - ignore_changes
date: 2025-08-04 22:00 +1300
categories: [Concepts & Tips, HashiCorp Terraform]
tags: [hashicorp, terraform, iac, automation, infrastructure]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

<br>

Have you ever heard of Terraform's nested `lifecycle` block?  
It allows you to control how resources behave during creation, update, and deletion operations.

One of the most useful attributes within this block is `ignore_changes`. This tells Terraform to ignore updates to specific resource arguments, preventing unnecessary diffs or rollbacks.

<br>
### Why use `ignore_changes`?

A common use case is the separation of responsibilities between teams. For example, the security or application team might need to make direct configuration changes in Azure that modify certain resource attributes. In such cases, you may not want Terraform to overwrite or revert those changes during the next `plan` or `apply`.

**Original code:**

```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "Australia East"
}

resource "azurerm_service_plan" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  name     = "asp-example2025"
  os_type  = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  name = "app-example2025"
  site_config {
    ip_restriction {
      ip_address = "13.107.6.0/24"
    }
  }
}
```

![](/assets/img/posts/terraform_lifecyle_iprestriction.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

---

After the deployment, the security team accessed the resource via the Azure portal and updated the IP address to `150.171.23.0/24`.

![](/assets/img/posts/terraform_lifecyle_iprestriction2.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>


When Terraform runs again, it compares the code with the current state of the resource. Since the IP address was updated outside of Terraform, it attempts to revert the change to match the declared configuration, as shown in the image below.

![](/assets/img/posts/terraform_lifecyle_tfplan_change.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br>

---

Now, if you use `ignore_changes` and include the IP attribute as shown below, Terraform will not attempt to revert the change made outside of Terraform.

### + ignore_changes code:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "Australia East"
}

resource "azurerm_service_plan" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  name     = "asp-example2025"
  os_type  = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  name = "app-example2025"

  site_config {
    ip_restriction {
      ip_address = "13.107.6.0/24"
    }
  }

  lifecycle {
    ignore_changes = [
      site_config[0].ip_restriction,
    ]
  }
}
```
![](/assets/img/posts/terraform_lifecyle_no_change.png){: .left }

<br><br><br>

---

<br>
> ### ⚠️ Important Consideration; <br> While ignore_changes is a powerful feature, it must be used carefully. Ignoring critical attributes can reduce visibility and allow changes that Terraform won’t track, increasing the risk of misconfigurations or security issues. <br><br> In the example above, there’s no defined process for managing IP changes outside Terraform. If someone’s credentials are compromised or a malicious change is made, and no one is monitoring it, you could face a serious issue without even knowing. <br><br> Always define how out-of-Terraform changes will be managed and who is responsible.
{: .prompt-warning }


Reference: [The lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)