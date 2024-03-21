variable "resource_group_name_db" {
    type = string
    description = "The name of the resource group in which the resources will be created"
  
}

variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
}

variable "key_vault_name" {
    type = string
    description = "value of the keyvault"
}

variable "server" {
    type = map(object({
        name = string
        version = string
        administrator_login = string
    }))
  
}

variable "database" {
    type = map(object({
        name = string
        server_name = string
        collation = string
        max_size_gb = number
        sku_name = string
        zone_redundant = bool
    }))
  
}