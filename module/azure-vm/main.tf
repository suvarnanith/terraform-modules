data "azurerm_subnet" "subnet" {
  for_each = var.nics
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

data "azurerm_resource_group" "rg" {
  for_each = var.nics
  name     = each.value.resource_group_name
}

data "azurerm_key_vault" "keyvault" {
    name = var.key_vault_name_cred
    resource_group_name = var.key_vault_rg
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "vmpass" {
  name         = "vm-admin-pw"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  value        = random_password.password.result
}

data "azurerm_key_vault_secret" "fetchvmpass" {
    name         = "vm-admin-pw"
    key_vault_id = data.azurerm_key_vault.keyvault.id
}


resource "azurerm_availability_set" "av" {
    for_each            = var.availability_set
    name                = each.value.name
    location            = each.value.location
    resource_group_name = each.value.resource_group_name
    tags = {
        "Resource Name" = "Availability-Set"
        "Environment" = var.environment
    }
  
}

resource "azurerm_network_interface" "nics" {
  for_each            = data.azurerm_subnet.subnet
  name                = each.key
  location            = data.azurerm_resource_group.rg[each.key].location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = each.value.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    "Resource Name" = "Network-Interface"
    "Environment" = var.environment
  }
}



resource "azurerm_virtual_machine" "vms" {
  depends_on = [ azurerm_availability_set.av, azurerm_network_interface.nics,azurerm_key_vault_secret.vmpass ]
  for_each            = var.vms
  name                = each.value.name
  vm_size             = each.value.vm_size
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  availability_set_id = azurerm_availability_set.av[each.value.avsetname].id
  network_interface_ids =  [azurerm_network_interface.nics[each.value.nicname].id,]
   storage_os_disk {
    name              = "myosdisk-${each.value.name}"
    caching           = each.value.os_disk.caching
    create_option     = each.value.os_disk.create_option
    managed_disk_type = each.value.os_disk.managed_disk_type
  }
  storage_image_reference {
    publisher = each.value.image_reference.publisher
    offer     = each.value.image_reference.offer
    sku       = each.value.image_reference.sku
    version   = each.value.image_reference.version
  }
  os_profile {
    computer_name  = each.value.os_profile.computer_name
    admin_username = each.value.os_profile.admin_username
    admin_password = data.azurerm_key_vault_secret.fetchvmpass.value
  }
   os_profile_linux_config {
    disable_password_authentication = each.value.linux_config.disable_password_authentication
  }
  tags = {
    "Resource Name" = "Virtual-Machine"
    "Environment" = var.environment
  }
}
