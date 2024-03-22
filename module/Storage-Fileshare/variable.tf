variable "fileshare"{
    type = map(object({
        name = string
        storage_account_name = string
        resource_group_name = string
        quota = number
    }))
    description = "The fileshare to be created in the storage account"
}
