variable "fileshare"{
    type = any
    default = []
    description = "The fileshare to be created in the storage account"
}

variable "storage_account_name" {
    type = string
    description = "The storage account to be created"
}

variable "resource_group_name" {
    type = string
    description = "The storage account to be created"
}
