# terraform-azurerm-sql-Server-Database
## Overview

This Terraform module provides a reusable and scalable way to manage Azure SQL Server and Database. It encapsulates the configuration and provisioning of Azure DB, allowing for consistent and repeatable deployments across environments.

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

module "database" {
  source = "../module/database"
  database = var.database
  server = var.server
  environment = var.environment
  resource_group_name_db = var.resource_group_name_db
  key_vault_name = var.key_vault_name_cred
  depends_on = [ module.resource_group, module.key-vault ]
}
  
```
# tfvars
```
resource_group_name_db = "rg1"

server = {
  server1 = {
    name = "server1"
    version = "12.0"
    administrator_login = "admin123"
  }
}

database = {
  db1 = {
    name = "db1"
    collation = "SQL_Latin1_General_CP1_CI_AS"
    server_name = "server1"
    max_size_gb = 1
    sku_name = "Basic"
    zone_redundant = false
  }
}
key_vault_name_cred = "keyvault1"

```

