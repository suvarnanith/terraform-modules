data "azurerm_resource_group" "lb-rg" {
  name = var.resource_group_name_lb
}

data "azurerm_subnet" "subnet" {
  for_each = var.load_balancers
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_lb" "lb" {
    for_each = data.azurerm_subnet.subnet
    name                = "lb-${each.key}"
    resource_group_name = data.azurerm_resource_group.lb-rg.name
    location            = data.azurerm_resource_group.lb-rg.location
    sku                 = var.lbsku
    frontend_ip_configuration {
        name                 = "frontend_ip_name_${each.key}"
        subnet_id            = each.value.id
    }
    tags = {
        "Resource Name" = "Load-Balancer"
        "Environment" = var.environment
    }
  
}
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
    for_each = var.load_balancers
    name                = "${each.value.name}-backend-pool"
    loadbalancer_id     = azurerm_lb.lb[each.value.name].id
    
}