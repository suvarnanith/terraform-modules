#create a storage account with container name
# locals {
#     is_private = var.is_private_endpoint == "True" ? var.private_endpoint : {}   
# }

data "azurerm_subnet" "subnet" {
  for_each = var.network_rules
  name = each.value.subnet_name
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
}

resource "azurerm_storage_account" "azurestorage" {
  for_each = var.storage_account
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  access_tier              = each.value.access_tier
  min_tls_version          = lookup(each.value, "min_tls_version", "TLS1_2")
  account_kind             = each.value.account_kind
  is_hns_enabled           = each.value.account_tier == "Standard" && each.value.account_kind == "StorageV2" && each.value.is_hns_enabled == "yes" ||each.value.account_tier == "Premium" ? true : false

    tags = {
        "Resource Name" = "Storage-Account"
        "Environment" = var.environment
    }
    network_rules {
        default_action             = "Deny"
        virtual_network_subnet_ids = [for subnet in data.azurerm_subnet.subnet : subnet.id]
    } 
    # dynamic "network_rules" {
    # for_each = var.network_rules != null ? [var.network_rules] : []
    # content {
    #   default_action             = "Deny"
    #   virtual_network_subnet_ids = var.network_rules.subnet_ids
    # }
    
}

