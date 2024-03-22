data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "kv-rg" {
  name = var.key_vault_rg
}

resource "azurerm_key_vault" "key-vault" {
  for_each = var.key_vault
  name                        = each.value.name
  resource_group_name          = data.azurerm_resource_group.kv-rg.name
  location                     = data.azurerm_resource_group.kv-rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled    = each.value.purge_protection_enabled
  enable_rbac_authorization   = each.value.enable_rbac_authorization
  sku_name                    = each.value.sku_name
  tags = {
    "Resource Name" = "Key Vault"
    "Environment" = var.environment
  }
}