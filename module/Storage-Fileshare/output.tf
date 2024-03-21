output "fileshare_name" {
  value = {for f in azurerm_storage_share.fileshare : f.storage_account_name => f.name}
}
