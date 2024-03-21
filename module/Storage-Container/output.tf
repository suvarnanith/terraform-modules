output "container_name" {
  value = {for c in azurerm_storage_container.container : c.storage_account_name => c.name}
}
