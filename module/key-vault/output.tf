output "key-vault" {
  value = [for kv in azurerm_key_vault.key-vault : kv.name]
  description = "The key vault to be created"
}