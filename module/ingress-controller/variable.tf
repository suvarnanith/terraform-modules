variable "aks_vnet_name" {
    type = string
    description = "The name of the virtual network"
  
}
variable "aks_name" {
    type = string
    description = "The name of the AKS cluster"
}
variable "resource_group_name_aks" {
    type = string
    description = "The name of the resource group in which the resources will be created"
}