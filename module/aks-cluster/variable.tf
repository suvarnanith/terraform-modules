variable "aks_name" {
    type = string
    description = "The name of the AKS cluster"
}
variable "resource_group_name_aks" {
    type = string
    description = "The name of the resource group in which the resources will be created"
}

variable "location" {
    type = string
    description = "The location/region in which the resources will be created"
}

variable "plugin" {
    type = string
    description = "The plugin to be used for the AKS cluster"
    default = "CNI"
}

variable "dns_service_ip" {
    type = string
    description = "The DNS service IP"
}

variable "servicecidr" {
    type = string
    description = "The service CIDR"
    default = "192.168.4.0/24"
}

variable "enableauto"{
    type = bool
    description = "Auto Scalling"
    default = false
}
variable "environment" {
    type = string
    description = "The environment in which the resources will be created"
  
}

variable "nodepoolname"{
    type = string
    description = "The name of the node pool"
    default = "nodepool1"
}

variable "nodepoolsize"{
    type = string
    description = "The VM size of the node pool"
    default = "Standard_D2_v2"
}

variable "osdisksize"{
    type = number
    description = "The OS Disk size"
    default = 128
}

# variable "appId" {
#     type = string
#     description = "The Application ID"
# }

# variable "password" {
#     type = string
#     sensitive = true
#     description = "The Secret"
# }
variable "dnsserviceip" {
    type = string
    description = "The DNS service IP"
    default = "192.168.4.100"
}

variable "loadbalancersku" {
    type = string
    description = "The SKU of the Load Balancer"
    default = "standard"
}

variable "networkpolicy" {
    type = string
    description = "The network policy"
    default = "azure"
}

variable "pluginmode" {
    type = string
    description = "The network plugin mode"
    default = "overlay"
}

variable "podcidr" {
    type = string
    description = "The pod CIDR"
    default = "192.168.0.0/22"
}

# variable "nodepoolversion" {
#     type = string
#     description = "The version of the node pool" 
# }

variable "disktype" {
    type = string
    description = "The disk type"
    default = "Managed"
}

variable "vmsstype" {
    type = string
    description = "The AKS VMSS type"
    default = "VirtualMachineScaleSets" 
}

variable "zone" {
    type = list(number)
    description = "The availability zones" 
    default = [2, 3]
}

variable "aks_subnet_name" {
    type = string
    description = "The name of the subnet"
  
}
variable "aks_vnet_name" {
    type = string
    description = "The name of the virtual network"
  
}