output "nic-id" {
    value = [for n in azurerm_network_interface.nics : n.id]
    description = "The network interface created"
}

output "vm-name" {
    value = [for v in azurerm_virtual_machine.vms : v.name]
    description = "The virtual machine created"
  
}