# terraform-azurerm-storage-fileshare
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Storage Account Fileshare. It encapsulates the configuration and provisioning of containers, allowing for consistent and repeatable deployments across environments.

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

module "fileshare_module" {
  source = "../module/Storage-Fileshare"
  fileshare = var.fileshare
  depends_on = [ module.storage_account_module ]
}
```
# tfvars
```

fileshare = {
  fileshare1 = {
    name                  = "file1"
    storage_account_name  = "nistore1"
    resource_group_name   = "rg1"
    quota = 1
  }
}

```

