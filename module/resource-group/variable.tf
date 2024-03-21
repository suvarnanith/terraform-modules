variable "resource_groups" {
  description = "The name of the resource group in which the resources will be created"
  type        = map(object({
    name = string
    location = string
  }))
}

variable "environment" {
    description = "The environment in which the resources will be created"
    type        = string
}
