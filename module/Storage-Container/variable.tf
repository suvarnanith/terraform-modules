variable "containers"{
    type = map(object({
        name = string
        storage_account_name = string
        resource_group_name = string
        container_access_type = string
    }))
    description = "The Container to be created in the storage account"
}