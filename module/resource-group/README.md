# terraform-azurerm-resource-group
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Resource Groups. It encapsulates the configuration and provisioning of Azure Resource Groups, allowing for consistent and repeatable deployments across environments.

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

module "resource_group" {
  source          = "../module/resource-group"
  resource_groups = var.resource_groups
  environment     = var.environment
}
```
# tfvars
```

#Resource Group
resource_groups = {
  rg1 = {
    name     = "rg1"
    location = "westus"
  }
  rg2 = {
    name     = "rg2"
    location = "eastus"
  }
}

```
