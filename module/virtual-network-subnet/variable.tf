variable "vnets" {
  type = map(object({
    address_space = string
    dns_servers = list(string)
    subnets = list(object({
      subnet_name    = string
      subnet_address = string
      service_endpoints = list(string)
    }))
  }))
}

variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
  
}

variable "resource_group_name_vnet" {
  type = string
  description = "The name of the resource group in which the resources will be created"
}
