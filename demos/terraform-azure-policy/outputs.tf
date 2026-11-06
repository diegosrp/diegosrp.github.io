output "resource_group_name" {
  description = "Name of the resource group used by the demo."
  value       = azurerm_resource_group.demo.name
}

output "storage_account_id" {
  description = "ID of the test storage account, when it is enabled."
  value       = try(azurerm_storage_account.test[0].id, null)
}
