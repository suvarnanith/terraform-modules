
data "azurerm_storage_account" "storage_account" {
    for_each = var.containers
    name = each.value.storage_account_name
    resource_group_name = each.value.resource_group_name
}

resource "azurerm_storage_container" "container" {
    for_each = var.containers
    name = each.value.name
    storage_account_name = data.azurerm_storage_account.storage_account[each.key].name
    container_access_type = each.value.container_access_type
}