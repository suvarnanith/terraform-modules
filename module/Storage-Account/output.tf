output "storage_account_id" {
  value = {for s in azurerm_storage_account.azurestorage : s.name => s.id}
  description = "value of the storage account created"
}
