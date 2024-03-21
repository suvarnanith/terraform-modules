locals {
  subnets_flatlist = flatten([for key, val in var.vnets : [
    for subnet in val.subnets : {
      vnet_name      = key
      subnet_name    = subnet.subnet_name
      subnet_address = subnet.subnet_address
      service_endpoints = subnet.service_endpoints
    }
    ]
  ])

  subnets = { for subnet in local.subnets_flatlist : "${subnet.subnet_name}:${subnet.subnet_address}" => subnet }
}



data "azurerm_resource_group" "network" {
  name = var.resource_group_name_vnet
}

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets
  name                = each.key
  resource_group_name = data.azurerm_resource_group.network.name
  location            = data.azurerm_resource_group.network.location
  address_space       = [each.value.address_space]
  dns_servers         = each.value.dns_servers
  tags = {
    "Resource Name" = "Virtual-Network"
    "Environment" = var.environment
    }
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.subnets
  name                 = each.value.subnet_name
  resource_group_name  = data.azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnets[each.value.vnet_name].name
  address_prefixes     = [each.value.subnet_address]
  service_endpoints    = each.value.service_endpoints
}
