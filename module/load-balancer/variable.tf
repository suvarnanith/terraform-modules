variable "load_balancers" {
    type = map(object({
        name = string
        subnet_name = string
        sku = string
        resource_group_name = string
        virtual_network_name = string
    }))
    description = "The load balancer to be created" 
}

variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
}

variable "resource_group_name_lb" {
    type = string
    description = "The name of the resource group in which the resources will be created"
  
}
variable "lbsku" {
    type = string
    description = "The SKU of the load balancer"
    default = "Standard"
  
}