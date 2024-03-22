# terraform-azurerm-storage-container
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Storage Account container. It encapsulates the configuration and provisioning of containers, allowing for consistent and repeatable deployments across environments.

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

module "container_module" {
  source = "../module/Storage-Container"
  containers = var.containers
  depends_on = [ module.storage_account_module ]
  
}
```
# tfvars
```

containers = {
  container1 = {
    name                  = "container1"
    storage_account_name  = "nistore1"
    resource_group_name   = "rg1"
    container_access_type = "private"
  }
  container2 = {
    name                  = "container2"
    storage_account_name  = "nistore2"
    resource_group_name   = "rg2"
    container_access_type = "private"
  }
}

```

