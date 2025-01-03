---
title: Understanding the blocks of Terraform
date: 2024-01-30 22:00 +1300
categories: [Concepts & Tips, HashiCorp Terraform]
tags: [hashicorp, terraform, iac, automation, infrastructure, governance, finops]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

### **Terraform is based on blocks, where each block has a specific function in defining infrastructure.**

#### **Some of the main blocks include:**
<a href="https://lnkd.in/gDnYQKPF" target="_blank">**resource:**</a> This block is used to declare a resource that will be created/managed by Terraform. A resource can be any object within the infrastructure that you want to manage, such as app service, resource groups, networks, etc.
<br>

Example:
![](https://stpersonalblog24.blob.core.windows.net/posts/block_resource.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br>

<a href="https://lnkd.in/gPAHrJcc" target="_blank">**data:**</a> This block is used to query existing data within the platform, such as information about an existing virtual machine, available images, etc. It allows you to bring external information into your Terraform code.
<br>

Example:
![](https://stpersonalblog24.blob.core.windows.net/posts/block_data.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

<a href="https://lnkd.in/gX7-KVP7" target="_blank">**variable:**</a> This block is used to define variables, which can be used to parameterize your modules or configurations. Variables enable greater flexibility and code reusability.
<br>

Example:
![](https://stpersonalblog24.blob.core.windows.net/posts/block_variable.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

<a href="https://lnkd.in/gsTy5Aax" target="_blank">**output:**</a> This block is used to define values that will be displayed when the infrastructure is provisioned. It can be useful for obtaining specific information after Terraform execution.
<br>

Example:
![](https://stpersonalblog24.blob.core.windows.net/posts/block_output.png){: .left }

<br>

<br><br><br><br><br><br><br><br><br>

<br>

<a href="https://lnkd.in/gbdfmr6f" target="_blank">**provider:**</a> This block is used to configure credentials and specific settings for the cloud provider you are using (e.g., Azure, AWS, Google Cloud).<br>

Example:

![](https://stpersonalblog24.blob.core.windows.net/posts/block_provider.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

<br>

<a href="https://lnkd.in/gSRrFVZf" target="_blank">**module:**</a> This block is used to encapsulate resources and configurations into a separate Terraform module. This is useful to promote modularity and reusability of the code, allowing you to organize and share specific parts of your infrastructure.
<br>

Example:
![](https://stpersonalblog24.blob.core.windows.net/posts/block_module.png){: .left }