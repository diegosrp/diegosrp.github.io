policytest {
  targets = ["../policies/allowed-azure-locations.policy.hcl"]

  terraform_config {
    required_version = ">= 1.17.0"
  }
}

inputs {
  allowed_locations = ["australiaeast"]
}

resource "azurerm_resource_group" "allowed_location" {
  attrs = {
    name     = "rg-policy-pass"
    location = "australiaeast"
  }
}

resource "azurerm_resource_group" "disallowed_location" {
  expect_failure = true

  attrs = {
    name     = "rg-policy-fail"
    location = "eastus"
  }
}

resource "azurerm_storage_account" "allowed_location" {
  attrs = {
    name                     = "stpolicypass123"
    resource_group_name      = "rg-policy-pass"
    location                 = "australiaeast"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "disallowed_location" {
  expect_failure = true

  attrs = {
    name                     = "stpolicyfail123"
    resource_group_name      = "rg-policy-fail"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}
