variable "deploy_test_storage" {
  description = "Whether to create the storage account used to test the policy."
  type        = bool
  default     = false
}

variable "resource_group_location" {
  description = "Azure region for the demo resource group."
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "Name of the isolated resource group used by this demo."
  type        = string
  default     = "rg-terraform-policy-demo"
}

variable "storage_account_location" {
  description = "Azure region for the test storage account; use a disallowed region to test denial."
  type        = string
  default     = "australiaeast"
}

variable "storage_account_name" {
  description = "Globally unique lowercase name for the test storage account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must contain 3 to 24 lowercase letters or numbers."
  }
}
