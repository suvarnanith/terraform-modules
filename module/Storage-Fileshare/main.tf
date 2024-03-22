data "azurerm_storage_account" "storage_account" {
    for_each = var.fileshare
    name = each.value.storage_account_name
    resource_group_name = each.value.resource_group_name
}

resource "azurerm_storage_share" "fileshare" {
  for_each             = var.fileshare
  name                 = each.value.name
  storage_account_name = data.azurerm_storage_account.storage_account[each.key].name
  quota                = each.value.quota
}