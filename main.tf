terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.19.1"
    }

    databricks = {
      source = "databrickslabs/databricks"
    }

    random = {}
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = format("%s%srg", var.application, var.environment)
  location = var.location
  tags     = merge(var.default_tags, tomap({ "type" = "resource" }))
}

module "aad" {
  source = "./modules/aad"

  aad_display_name = format("%s%ssp", var.application, var.environment)
}

module "key-vault" {
  source = "./modules/keyvault"
  depends_on = [
    azurerm_resource_group.resource_group,
    module.aad
  ]

  resource_group_name = azurerm_resource_group.resource_group.name
  name                = format("%s%skv", var.application, var.environment)
  location            = var.location
  sub_tenantid        = data.azurerm_client_config.current.tenant_id
  adgroup_id          = module.aad.ad_group_id
  sp_secret_id        = module.aad.sp_secret_id
  sp_secret_value     = module.aad.sp_secret_value
  tags                = merge(var.default_tags, tomap({ "type" = "resource" }))
}
