data "azurerm_resource_group" "lb-rg" {
  name = var.resource_group_name_db
}

data "azurerm_key_vault" "keyvault" {
    name = var.key_vault_name_cred
    resource_group_name = data.azurerm_resource_group.lb-rg.name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "dbpass" {
  name         = "db-admin-pw"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  value        = random_password.password.result
}

data "azurerm_key_vault_secret" "fetchdbpass" {
    name         = "db-admin-pw"
    key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_mssql_server" "sqlserver" {
  depends_on = [ azurerm_key_vault_secret.dbpass ]
  for_each = var.server
  name                         = each.value.name
  resource_group_name          = data.azurerm_resource_group.lb-rg.name
  location                     = data.azurerm_resource_group.lb-rg.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = data.azurerm_key_vault_secret.fetchdbpass.value
  tags = {
    "Resource Name" = "SQL Server"
    "Environment" = var.environment
  }
}

resource "azurerm_mssql_database" "db" {
  for_each = var.database
  name           = each.value.name
  server_id      = azurerm_mssql_server.sqlserver[each.value.server_name].id
  collation      = each.value.collation
  max_size_gb    = each.value.max_size_gb
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant

  tags = {
    "Resource Name" = "DB"
    "Environment" = var.environment
  }
}