data "azurerm_resource_group" "nsg"{
    name = var.resource_group_name_nsg
}

resource "azurerm_network_security_group" "nsg" {
    resource_group_name = data.azurerm_resource_group.nsg.name
    location = data.azurerm_resource_group.nsg.location
    name = var.nsgname
    tags = {
      "Resource Name" = "Network-Security-Group"
      "Environment" = var.environment
    }

    }
  

resource "azurerm_network_security_rule" "custom_rules" {
  for_each = {for value in var.custom_rules : value.name => value}

  access                                     = lookup(each.value, "access", "Allow")
  direction                                  = lookup(each.value, "direction", "Inbound")
  name                                       = lookup(each.value, "name", "default_rule_name")
  network_security_group_name                = each.value.nsgname
  priority                                   = each.value.priority
  protocol                                   = lookup(each.value, "protocol", "*")
  resource_group_name                        = data.azurerm_resource_group.nsg.name
  description                                = lookup(each.value, "description", "Security rule for ${lookup(each.value, "name", "default_rule_name")}")
  destination_address_prefix                 = lookup(each.value, "destination_application_security_group_ids", null) == null && lookup(each.value, "destination_address_prefixes", null) == null ? lookup(each.value, "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(each.value, "destination_application_security_group_ids", null) == null ? lookup(each.value, "destination_address_prefixes", null) : null
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  destination_port_ranges                    = split(",", replace(lookup(each.value, "destination_port_range", "*"), "*", "0-65535"))
  source_address_prefix                      = lookup(each.value, "source_application_security_group_ids", null) == null && lookup(each.value, "source_address_prefixes", null) == null ? lookup(each.value, "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(each.value, "source_application_security_group_ids", null) == null ? lookup(each.value, "source_address_prefixes", null) : null
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  source_port_range                          = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(each.value, "source_port_range", "*") == "*" ? null : [for r in split(",", each.value.source_port_range) : trimspace(r)]
}
