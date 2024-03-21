variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
  
}

variable "storage_account" {
    type = map(object({
        name = string
        location = string
        resource_group_name = string
        account_tier = string
        account_replication_type = string
        access_tier = string
        min_tls_version = string
        account_kind = string
        is_hns_enabled = string
    }))
  
}

# variable "network_rules" {
#   description = "Network rules restricing access to the storage account."
#   type        = object({  subnet_ids = list(string) })
#   default     = null
# }

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = map(object({
    subnet_name = string
    vnet_name = string
    resource_group_name = string
  }))
  default     = null
  
}

