# terraform-azurerm-network-security-group
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Network Security Group. It encapsulates the configuration and provisioning of Azure NSG, allowing for consistent and repeatable deployments across environments. This module will create a NSG and can add multiple NSG rules.

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

module "nsg" {
  source = "../module/nsg"
  resource_group_name_nsg = var.resource_group_name_nsg
  nsgname = var.nsgname
  custom_rules = var.custom_rules
  environment = var.environment
  
}
```
# tfvars
```

Variable "nsgname" {
  type = string
  description = "NSG name"
}

custom_rules = [
    {
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      nsgname                = "nsg1"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.151.0.0/24"
      description            = "description-myssh"
    },
    {
      name                    = "myhttp"
      priority                = 200
      direction               = "Inbound"
      nsgname                 = "nsg2"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      destination_port_range  = "8080"
      source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
      description             = "description-http"
    },
  ]

```

