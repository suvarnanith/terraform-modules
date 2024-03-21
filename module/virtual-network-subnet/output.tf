output "vnet" {
    value =  [for v in azurerm_virtual_network.vnets : v.name]
    description = "The virtual network created"
}

output "subnet" {
    value = [for s in azurerm_subnet.subnets : s.name]
}