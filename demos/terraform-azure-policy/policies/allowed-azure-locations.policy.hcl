policy {
  terraform_config {
    required_version = ">= 1.17.0"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

input "allowed_locations" {
  type        = list(string)
  description = "Canonical Azure location names allowed by the policy."
  default     = ["australiaeast"]
  nullable    = false
}

resource_policy "azurerm_resource_group" "allowed_location" {
  enforcement_level = "mandatory"
  operations        = ["create", "update"]

  enforce {
    condition     = core::contains(input.allowed_locations, attrs.location)
    error_message = "Resource group location is not in the approved Azure locations list."
  }
}

resource_policy "azurerm_storage_account" "allowed_location" {
  enforcement_level = "mandatory"
  operations        = ["create", "update"]

  enforce {
    condition     = core::contains(input.allowed_locations, attrs.location)
    error_message = "Storage account location is not in the approved Azure locations list."
  }
}
