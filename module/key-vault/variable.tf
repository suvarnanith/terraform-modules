variable "resource_group_name_db" {
    type = string
    description = "The name of the resource group in which the resources will be created"
  
}
variable "key_vault" {
    type = map(object({
        name = string
        sku_name = string
        soft_delete_retention_days = number
        purge_protection_enabled = bool
        enable_rbac_authorization = bool
        sku_name = string
    }))
    description = "The key vault to be created"
}

variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
}
