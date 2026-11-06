resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "test" {
  count = var.deploy_test_storage ? 1 : 0

  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = var.storage_account_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    purpose = "terraform-policy-demo"
  }
}
