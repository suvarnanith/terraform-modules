# terraform-azurerm-Load-Balancer
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Load Balancer. It encapsulates the configuration and provisioning of Azure LB, allowing for consistent and repeatable deployments across environments.

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

module "load-balancer" {
  source = "../module/load-balancer"
  load_balancers = var.load_balancers
  environment = var.environment
  resource_group_name_lb = var.resource_group_name_lb
  depends_on = [ module.virtual_machine ]
}
  
```
# tfvars
```
load_balancers = {
  "lb1" = {
    name                = "lb1"
    subnet_name         = "subnet1"
    sku                 = "standard"
    resource_group_name = "rg1"
    virtual_network_name = "vnet1"
  }
  "lb2" = {
    name                = "lb2"
    subnet_name         = "subnet2"
    sku                 = "standard"
    resource_group_name = "rg1"
    virtual_network_name = "vnet1"
  }
}
resource_group_name_lb = "rg1"

```

