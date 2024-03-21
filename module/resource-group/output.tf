    output "rg_name" {
    value = {for r in azurerm_resource_group.rg : r.name => r.id}
    description = "name of the resource group created"
}

output "rg_location" {
    value = {for r in azurerm_resource_group.rg : r.name => r.location}
    description = "location of the resource group created"
}