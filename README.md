# Terraform-Modules

This Terraform module deploys a Resource Group, Virtual Network, Subnet, VM, Network Security Group, Database, Storage Account, Container, Load Balancer in Azure. Calling the child module once and build multiple resources by passing the map of variables.

For_each loop has been used in the every module.

# Example for calling the child module.

```
# Resource-1: Azure Resource Group
module "resource_group" {
  source          = "../module/resource-group"
  resource_groups = var.resource_groups
  environment     = var.environment
}

#Storage Account-1: Azure Storage Account
module "storage_account_module" {
  source = "../module/Storage-Account"
  storage_account = var.storage_account
  environment = var.environment
  network_rules = var.network_rules
  depends_on = [ module.resource_group, module.virtual_network ]

}
#Azure Storage Container
module "container_module" {
  source = "../module/Storage-Container"
  containers = var.containers
  depends_on = [ module.storage_account_module ]
  
}
#Azure Vnet and Subnet
module "virtual_network" {
  source = "../module/virtual-network-subnet"
  vnets = var.vnets
  environment = var.environment
  resource_group_name_vnet = var.resource_group_name_vnet
  depends_on = [ module.resource_group ]
}

#Azure VM
module "virtual_machine" {
  source = "../module/azure-vm"
  vms = var.vms
  environment = var.environment
  key_vault_name = var.key_vault_name
  key_vault_rg = var.key_vault_rg
  nics = var.nics
  availability_set = var.availability_set
  depends_on = [ module.virtual_network ]
}

#Azure Load balancer
module "load-balancer" {
  source = "../module/load-balancer"
  load_balancers = var.load_balancers
  environment = var.environment
  resource_group_name_lb = var.resource_group_name_lb
  depends_on = [ module.virtual_machine ]
}

#Azure Database
module "database" {
  source = "../module/database"
  database = var.database
  server = var.server
  environment = var.environment
  resource_group_name_db = var.resource_group_name_db
  key_vault_name = var.key_vault_name
  depends_on = [ module.resource_group, module.key-vault ]
}

#Azure Key vault
module "key-vault" {
  source = "../module/key-vault"
  key_vault = var.key_vault
  environment = var.environment
  resource_group_name_db = var.resource_group_name_db
  depends_on = [ module.resource_group ]
}

module "nsg" {
  source = "../module/nsg"
  resource_group_name_nsg = var.resource_group_name_nsg
  nsgname = var.nsgname
  custom_rules = var.custom_rules
  environment = var.environment
  
}
```


Example for passing the variables to create multiple resources which should be in tfvars file.

```
#Stage
environment = "dev"

#Resource Group
resource_groups = {
  rg1 = {
    name     = "rg1"
    location = "westus"
  }
  rg2 = {
    name     = "rg2"
    location = "eastus"
  }
}


#Storage Variable
storage_account = {
  storage1 = {
    name                = "nistore1"
    resource_group_name = "rg1"
    location            = "westus"
    account_tier        = "Standard"
    account_replication_type = "LRS"
    access_tier         = "Hot"
    min_tls_version     = "TLS1_2"
    account_kind        = "StorageV2"
    is_hns_enabled      = false
    service_vnet_name = "subnet1"
    service_subnet_name = "vnet1"
  }
  storage2 = {
    name                = "nistore2"
    resource_group_name = "rg2"
    location            = "eastus"
    account_tier        = "Standard"
    account_replication_type = "GRS"
    min_tls_version     = "TLS1_2"
    access_tier         = "Hot"
    account_kind        = "StorageV2"
    is_hns_enabled      = true
    service_vnet_name = "subnet1"
    service_subnet_name = "vnet1"
  }
}

network_rules = {
  subnet_ids1 = {
    vnet_name = "vnet1"
    resource_group_name  = "rg1"
    subnet_name = "subnet1"
  },
  subnet_ids2 = {
    vnet_name = "vnet1"
    resource_group_name  = "rg1"
    subnet_name = "subnet2"
  }
}

#container Variable

containers = {
  container1 = {
    name                  = "container1"
    storage_account_name  = "nistore1"
    resource_group_name   = "rg1"
    container_access_type = "private"
  }
  container2 = {
    name                  = "container2"
    storage_account_name  = "nistore2"
    resource_group_name   = "rg2"
    container_access_type = "private"
  }
}

#Vnet and subnet Variable
vnets = {
  vnet1 = {
    address_space = "10.0.0.0/16"
    resource_group_name = "rg1"
    dns_servers = ["10.0.0.4", "10.0.0.5"]
    subnets = [
      {
        subnet_name    = "subnet1"
        subnet_address = "10.0.0.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      },
      {
        subnet_name    = "subnet2"
        subnet_address = "10.0.1.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
      ]}
  vnet2 = {
    address_space = "10.1.0.0/16"
    resource_group_name = "rg1"
    dns_servers = ["10.0.0.4", "10.0.0.5"]
    subnets = [
      {
        subnet_name    = "subnet1"
        subnet_address = "10.1.0.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      },
      {
        subnet_name    = "subnet2"
        subnet_address = "10.1.1.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
      ]}
}
resource_group_name_vnet = "rg1"

#VM, Network Interface and Availability Set Variable

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

#load Balancer

load_balancers = {
  "lb1" = {
    name                = "lb1"
    subnet_name         = "subnet1"
    sku                 = "standard"
    resource_group_name = "rg1"
    virtual_network_name = "vnet1"
  }
  "lb2" = {
    name                = "lb2"
    subnet_name         = "subnet2"
    sku                 = "standard"
    resource_group_name = "rg1"
    virtual_network_name = "vnet1"
  }
}
resource_group_name_lb = "rg1"

#DB
resource_group_name_db = "rg1"

server = {
  server1 = {
    name = "server1"
    version = "12.0"
    administrator_login = "admin123"
  }
}

database = {
  db1 = {
    name = "db1"
    collation = "SQL_Latin1_General_CP1_CI_AS"
    server_name = "server1"
    max_size_gb = 1
    sku_name = "Basic"
    zone_redundant = false
  }
}

#key Vault

key_vault_name = "keyvault1"
key_vault_rg = "rg1"

key_vault = {
  "key_vault1" = {
    name                = "keyvault1"
    sku_name            = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled = true
    enable_rbac_authorization = true
    
  }
}

#NSG

network_security_group = {
  "1" = {
    name = "nsg1"
  }
  "2" = {
    name = "nsg2"
  }
}

custom_rules = [
    {
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      nsgname                = "nsg1"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.151.0.0/24"
      description            = "description-myssh"
    },
    {
      name                    = "myhttp"
      priority                = 200
      direction               = "Inbound"
      nsgname                 = "nsg2"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      destination_port_range  = "8080"
      source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
      description             = "description-http"
    },
  ]
```


