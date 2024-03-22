# terraform-azurerm-key-vault
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Key Vault. It encapsulates the configuration and provisioning of Azure KV, allowing for consistent and repeatable deployments across environments.

# Usage

```
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
}

module "key-vault" {
  source = "../module/key-vault"
  key_vault = var.key_vault
  environment = var.environment
  resource_group_name_db = var.resource_group_name_db
  depends_on = [ module.resource_group ]
}
  
```
# tfvars
```
key_vault = {
  "key_vault1" = {
    name                = "keyvault1"
    sku_name            = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled = true
    enable_rbac_authorization = true
    
  }
}
key_vault_rg = "rg1"

```

