# terraform-azurerm-storage-account
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Storage Accounts. It encapsulates the configuration and provisioning of Azure Storage Accounts, allowing for consistent and repeatable deployments across environments.

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

module "storage_account_module" {
  source = "../module/Storage-Account"
  storage_account = var.storage_account
  environment = var.environment
  network_rules = var.network_rules
  depends_on = [ module.resource_group, module.virtual_network ]

}
```
# tfvars
```

storage_account = {
  storage1 = {
    name                = "nistore1"
    resource_group_name = "rg1"
    location            = "westus"
    account_tier        = "Standard"
    account_replication_type = "LRS"
    access_tier         = "Hot"
    min_tls_version     = "TLS1_2"
    account_kind        = "StorageV2"
    is_hns_enabled      = false
    service_vnet_name = "subnet1"
    service_subnet_name = "vnet1"
  }
  storage2 = {
    name                = "nistore2"
    resource_group_name = "rg2"
    location            = "eastus"
    account_tier        = "Standard"
    account_replication_type = "GRS"
    min_tls_version     = "TLS1_2"
    access_tier         = "Hot"
    account_kind        = "StorageV2"
    is_hns_enabled      = true
    service_vnet_name = "subnet1"
    service_subnet_name = "vnet1"
  }
}

network_rules = {
  subnet_ids1 = {
    vnet_name = "vnet1"
    resource_group_name  = "rg1"
    subnet_name = "subnet1"
  },
  subnet_ids2 = {
    vnet_name = "vnet1"
    resource_group_name  = "rg1"
    subnet_name = "subnet2"
  }
}

```

