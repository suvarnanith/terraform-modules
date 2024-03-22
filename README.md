# Terraform-Modules

Terraform modules are reusable, self-contained units of infrastructure configuration that encapsulate and abstract away specific pieces of infrastructure or functionality. They enable users to package infrastructure configurations into modular components, promoting consistency, reusability, and maintainability across projects.

With Terraform modules, infrastructure configurations can be organized into smaller, manageable units, similar to building blocks. These modules can represent anything from simple resources like a virtual machine or a network subnet to complex multi-tier architectures.

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

 module "container_module" {
    source = "../module/Storage-Container"
    containers = var.containers
    depends_on = [ module.storage_account_module ]
  
}

module "fileshare_module" {
  source = "../module/Storage-Fileshare"
  fileshare = var.fileshare
  depends_on = [ module.storage_account_module ]
}

module "virtual_network" {
  source = "../module/virtual-network-subnet"
  vnets = var.vnets
  environment = var.environment
  resource_group_name_vnet = var.resource_group_name_vnet
  depends_on = [ module.resource_group ]
}

module "virtual_machine" {
  source = "../module/azure-vm"
  vms = var.vms
  environment = var.environment
  key_vault_name_cred = var.key_vault_name_cred
  resource_group_name_kv = var.resource_group_name_kv
  nics = var.nics
  availability_set = var.availability_set
  depends_on = [ module.virtual_network, module.key-vault ]
}

module "load-balancer" {
  source = "../module/load-balancer"
  load_balancers = var.load_balancers
  environment = var.environment
  resource_group_name_lb = var.resource_group_name_lb
  depends_on = [ module.virtual_machine ]
}

module "database" {
  source = "../module/database"
  database = var.database
  server = var.server
  environment = var.environment
  resource_group_name_db = var.resource_group_name_db
  key_vault_name_cred = var.key_vault_name_cred
  depends_on = [ module.resource_group, module.key-vault ]
}

module "key-vault" {
  source = "../module/key-vault"
  key_vault = var.key_vault
  environment = var.environment
  resource_group_name_kv = var.resource_group_name_kv
  depends_on = [ module.resource_group ]
}

module "nsg" {
  source = "../module/nsg"
  resource_group_name_nsg = var.resource_group_name_nsg
  nsgname = var.nsgname
  custom_rules = var.custom_rules
  nsg_virtual_network_name = var.nsg_virtual_network_name
  nsg_subnet = var.nsg_subnet
  environment = var.environment
  depends_on = [ module.resource_group,module.virtual_network ]
}
```


# Example for passing the variables to create multiple resources which should be in tfvars file.

```
resource_groups = {
  rg1 = {
    name     = "rg1"
    location = "westus"
  }
}
environment = "dev"

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
}

containers = {
  container1 = {
    name                  = "container1"
    storage_account_name  = "nistore1"
    resource_group_name   = "rg1"
    container_access_type = "private"
  }
}

fileshare = {
  fileshare1 = {
    name                  = "file1"
    storage_account_name  = "nistore1"
    resource_group_name   = "rg1"
    quota = 1
  }
}
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
      computer_name  = "vm2"
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
key_vault_name_cred = "nithvault2"
resource_group_name_kv = "rg1"

key_vault = {
  "key_vault1" = {
    name                = "nithvault2"
    sku_name            = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled = true
    enable_rbac_authorization = true
    
  }
}

nsgname = "nsg1"

custom_rules = [
    {
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
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
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      destination_port_range  = "8080"
      source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
      description             = "description-http"
    },
  ]

  resource_group_name_nsg = "rg1"
  nsg_subnet = "subnet1"
  nsg_virtual_network_name = "vnet1"
  
```
# Output.tf

```

# 1. Output Values - Resource Group
output "rg_name" {
  value = module.resource_group.rg_name
  description = "Name of the resource group created"
  
}

output "storage_id" {
  value = module.storage_account_module.storage_account_id
  description = "Name of the resource group created"
  
}
output "container_name" {
  value = module.container_module.container_name
  description = "Name of the resource group created"
  
}

output "vnet_output" {
  value = module.virtual_network.vnet
  description = "The virtual network created"
  
}

output "subnet_output" {
  value = module.virtual_network.subnet
  description = "The subnet created"
  
}

output "nic_id" {
  value = module.virtual_machine.nic-id
  description = "The network interface created"
}

output "vm_name" {
  value = module.virtual_machine.vm-name
  description = "The virtual machine created"
  
}

output "name_id" {
  value = module.load-balancer.lb-id
  description = "The load balancer created"
}

output "server_name" {
  value = module.database.server_name
  description = "The database server created"
  
}

output "database_name" {
  value = module.database.database_name
  description = "The database created"
}

output "key_vault_name" {
  value = module.key-vault.key-vault
  description = "The key vault created"
  
}
```
