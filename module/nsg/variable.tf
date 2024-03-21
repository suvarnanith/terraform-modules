
variable "resource_group_name_nsg" {
  type        = string
  description = "Name of the resource group"
}
variable "custom_rules" {
  type        = any
  default     = []
  description = "Security rules for the network security group using this format name = [name, priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
}

variable "nsgname" {
  type = string
  description = "NSG Name"
}
variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
  
}