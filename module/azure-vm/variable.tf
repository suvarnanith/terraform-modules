variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
}

variable "nics" {
    type = map(object({
        name = string
        location = string
        resource_group_name = string
        subnet_name = string
        virtual_network_name = string
    }))
}

variable "vms" {
    type = map(object({
        name = string
        location = string
        resource_group_name = string
        vm_size = string
        nicname = string
        avsetname = string
        os_disk = object({
            caching = string
            managed_disk_type = string
            create_option = string
        })
        image_reference = object({
            publisher = string
            offer     = string
            sku       = string
            version   = string
       })
        os_profile = object({
            computer_name = string
            admin_username = string
        })
        linux_config = object({
        disable_password_authentication = bool
        })
    }))
  
}

variable "availability_set" {
    type = map(object({
        name = string
        location = string
        resource_group_name = string
    }))
  
}
variable "key_vault_name" {
    type = string
    description = "value of the keyvault"
}
variable "key_vault_rg" {
    type = string
    description = "value of the keyvault"
}