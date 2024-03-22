# terraform-azurerm-virtual-network
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Virtual Networks and Subnets. It encapsulates the configuration and provisioning of Virtual Networks and Subnets, allowing for consistent and repeatable deployments across environments.

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

module "virtual_network" {
  source = "../module/virtual-network-subnet"
  vnets = var.vnets
  environment = var.environment
  resource_group_name_vnet = var.resource_group_name_vnet
  depends_on = [ module.resource_group ]
}
```
# tfvars
```

vnets = {
  vnet1 = {
    address_space = "10.0.0.0/16"
    resource_group_name = "rg1"
    dns_servers = ["10.0.0.4", "10.0.0.5"]
    subnets = [
      {
        subnet_name    = "subnet1"
        subnet_address = "10.0.0.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      },
      {
        subnet_name    = "subnet2"
        subnet_address = "10.0.1.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
      ]}
  vnet2 = {
    address_space = "10.1.0.0/16"
    resource_group_name = "rg1"
    dns_servers = ["10.0.0.4", "10.0.0.5"]
    subnets = [
      {
        subnet_name    = "subnet1"
        subnet_address = "10.1.0.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      },
      {
        subnet_name    = "subnet2"
        subnet_address = "10.1.1.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
      ]}
}
resource_group_name_vnet = "rg1"

```

