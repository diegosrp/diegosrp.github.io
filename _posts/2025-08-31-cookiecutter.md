---
title: Automate and standardize Terraform with Cookiecutter
date: 2025-08-31 07:00 +1300
categories: [Automation, Terraform]
tags: [cookiecutter, hashicorp, terraform, iac, automation, infrastructure]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

## What is Cookiecutter?

[Cookiecutter](https://cookiecutter.readthedocs.io/en/stable/README.html) is a command-line utility that quickly creates new projects from templates. It helps teams standardize structure, automate best practices, and start every project with the right foundation.

With Cookiecutter, you define variables that users fill in when creating a project, so every new project follows your team's standards.

**Highlights:**
- Generate projects from local or remote templates
- Prompt users for custom values
- Automate setup with pre/post hooks
- Use Jinja2 templating for flexibility

## Why use Cookiecutter?

- **Standardization:** All projects follow the same structure.
- **Automation:** Less manual work, fewer mistakes.
- **Fast onboarding:** New projects are ready in minutes.
- **Flexible:** Works for any language or framework.

---

## Let's start our Terraform AzureRM template

We will use the file structure recommended by [HashiCorp](https://developer.hashicorp.com/terraform/language/style#file-names) to create a solid starting point for any Terraform AzureRM project. This approach keeps our setup organized.

### Template Structure

![](/assets/img/posts/cookiecutter_tree.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br>

### Customizations:

#### **cookiecutter.json**

![](/assets/img/posts/cookiecutter_json.png){: .left }

In this file, we define the variables that users will fill in when creating a new project. We also use Jinja2 expressions to customize the values provided. For example, the repository name uses the prefix "tf-azurerm-" and automatically inserts the project name in lowercase, replacing spaces with hyphens (-).

#### **hooks/pre_gen_project.py**

![](/assets/img/posts/cookiecutter_pre_gen_project.png){: .left }

We use Python to validate user input before creating the project. This ensures all values are in the correct format and helps prevent errors later on.


#### **/backend.tf**

![](/assets/img/posts/cookiecutter_backend.png){: .left }

We are using the local backend to store the Terraform state file. The state filename is generated automatically from the project name it is converted to lowercase, and spaces or hyphens are replaced with underscores (_).  

#### **/locals.tf**

![](/assets/img/posts/cookiecutter_locals.png){: .left }

Here we define local variables to keep the code clean and consistent. We combine the project name and environment to create standardized names for resources, like resource groups.

#### **/README.md**

![](/assets/img/posts/cookiecutter_readme.png){: .left }

Substituting variables in the README file helps users understand the project context right away. It includes the project name and a brief overview of the repository's purpose.

#### **/terraform.tf**

![](/assets/img/posts/cookiecutter_terraform.png){: .left }

Includes the required Terraform version and provider constraints, based on user input. This ensures compatibility and helps avoid version-related issues.

#### **/variables.tf**

![](/assets/img/posts/cookiecutter_variables.png){: .left }

Defines input variables with descriptions, types, and default values. It also includes validation rules to ensure correct formats, such as for the Azure Subscription ID.
<br>

> Note all the files in the template use Jinja2 templating to substitute variables based on user input, ensuring consistency across the project.
{: .prompt-warning }


---

## Practical Example: Step by Step

### 1. Install Cookiecutter

```sh
pip install cookiecutter
```

### 2. Generate a new project

```sh
cookiecutter https://github.com/diegosrp/cookiecutter-tf-template.git
```

### 3. Answer the prompts

![](/assets/img/posts/cookiecutter_prompt.png){: .left }

Notice that I answered the project name, Terraform version, and environment. The rest I left as default, as set in cookiecutter.json.

### 4. Generated result

The generated directory will look like this:

```text
tf-azurerm-my-project-azure/
├── .gitignore
├── backend.tf
├── data.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── terraform.tf
├── terraform.tfvars
└── variables.tf
```

#### backend.tf
```hcl
terraform {
  backend "local" {
    path = "my_project_azure.tfstate"
  }
}
```

#### locals.tf
```hcl
locals {
  project_name = "my-project-azure-dev"
}
```

#### terraform.tf
```hcl
terraform {
  required_version = ">= 1.12.0, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

```

#### variables.tf
```hcl
variable "subscription_id" {
  description = "Azure Subscription ID used to create resources"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}", var.subscription_id))
    error_message = "The subscription_id must be a valid Azure Subscription GUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."
  }
}

variable "location" {
  description = "Default Azure location for resources"
  type        = string
  default     = "australia east"
}

variable "default_tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    project     = "my project-azure"
    environment = "dev"
    deployment  = "terraform"
  }
}
```

Set your subscription_id and you're ready to go!

---

### 5. Running Terraform

Now, inside your project directory, run:

```sh
terraform init
terraform plan
```

The output of `terraform plan` will look something like this:

```sh
Terraform will perform the following actions:

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "australiaeast"
      + name     = "rg-my-project-azure-dev"
      + tags     = {
          + "deployment"  = "terraform"
          + "environment" = "dev"
          + "project"     = "my project-azure"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## Conclusion

In this example, we showed how to create a basic template to standardize versions, file structure, and naming conventions for Terraform projects.

But you can take it much further! Here are some ideas:

- Add pre-commit hooks to check syntax, formatting, and best practices automatically.
- Create templates for multi-provider setups, using hooks to add specific blocks or files depending on the provider (Azure, AWS, GCP, etc).
- Standardize directories for CI/CD pipelines, tests, and automation.
- Automate the inclusion of modules and integrations.

As you can see, Cookiecutter is a powerful way to speed up and standardize new project creation, ensuring consistency and best practices from the very start.

<br>

**Repository:** [https://github.com/diegosrp/cookiecutter-tf-template](https://github.com/diegosrp/cookiecutter-tf-template)