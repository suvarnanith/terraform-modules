# terraform-azurerm-virtual-machine
## Overview

This Terraform module provides a reusable and scalable way to manage Azure Virtual Machine. It encapsulates the configuration and provisioning of Azure VM, allowing for consistent and repeatable deployments across environments.

# Usage

```
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
}

module "virtual_machine" {
  source = "../module/azure-vm"
  vms = var.vms
  environment = var.environment
  key_vault_name = var.key_vault_name_cred
  key_vault_rg = var.key_vault_rg
  nics = var.nics
  availability_set = var.availability_set
  depends_on = [ module.virtual_network ]
}

  
```
# tfvars
```
nics = {
  nic1 = {
    name = "nic1"
    location = "westus"
    resource_group_name = "rg1"
    subnet_name = "subnet1"
    virtual_network_name = "vnet1"
  }
  nic2 = {
    name = "nic2"
    location = "westus"
    resource_group_name = "rg1"
    subnet_name = "subnet1"
    virtual_network_name = "vnet1"
  }
  nic3 = {
    name = "nic3"
    location = "westus"
    resource_group_name = "rg1"
    subnet_name = "subnet2"
    virtual_network_name = "vnet1"
  }
  nic4 = {
    name = "nic4"
    location = "westus"
    resource_group_name = "rg1"
    subnet_name = "subnet2"
    virtual_network_name = "vnet1"
  }
}

vms = {
  vm1 = {
    name                = "vm1"
    location            = "westus"
    resource_group_name = "rg1"
    vm_size             = "Standard_DS1_v2"
    nicname             = "nic1"
    avsetname           = "avset1"
    os_disk = {
      caching          = "ReadWrite"
      managed_disk_type = "Standard_LRS"
      create_option    = "FromImage"
    }
    image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
    }
    os_profile = {
      computer_name  = "vm1"
      admin_username = "adminuser"
    }
    linux_config = {
      disable_password_authentication = false
    }
  }
  vm2 = {
    name                = "vm2"
    location            = "westus"
    resource_group_name = "rg1"
    vm_size             = "Standard_DS1_v2"
    nicname             = "nic2"
    avsetname           = "avset1"
    os_disk = {
      caching          = "ReadWrite"
      managed_disk_type = "Standard_LRS"
      create_option    = "FromImage"
    }
    image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
    }
    os_profile = {
      computer_name  = "vm2"
      admin_username = "adminuser"
    }
    linux_config = {
      disable_password_authentication = false
    }
  }
  vm3 = {
    name                = "vm3"
    location            = "westus"
    resource_group_name = "rg1"
    vm_size             = "Standard_DS1_v2"
    nicname             = "nic3"
    avsetname           = "avset2"
    os_disk = {
      caching          = "ReadWrite"
      managed_disk_type = "Standard_LRS"
      create_option    = "FromImage"
    }
    image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
    }
    os_profile = {
      computer_name  = "vm3"
      admin_username = "adminuser"
    }
    linux_config = {
      disable_password_authentication = false
    }
  }
  vm4 = {
    name                = "vm4"
    location            = "westus"
    resource_group_name = "rg1"
    vm_size             = "Standard_DS1_v2"
    nicname             = "nic4"
    avsetname           = "avset2"
    os_disk = {
      caching          = "ReadWrite"
      managed_disk_type = "Standard_LRS"
      create_option    = "FromImage"
    }
    image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04.0-LTS"
      version   = "latest"
    }
    os_profile = {
      computer_name  = "vm4"
      admin_username = "adminuser"
    }
    linux_config = {
      disable_password_authentication = false
    }
  }
}
availability_set = {
  avset1 = {
    name                = "avset1"
    location            = "westus"
    resource_group_name = "rg1"
  }
  avset2 = {
    name                = "avset2"
    location            = "westus"
    resource_group_name = "rg1"
  }

}
key_vault_name_cred = "keyvault1"

```

