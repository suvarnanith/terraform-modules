output "server_name" {
    value = [for s in azurerm_mssql_server.sqlserver : s.name]
    description = "The name of the SQL Server"
}

output "database_name" {
    value = [for d in azurerm_mssql_database.db : d.name]
    description = "The name of the SQL Database"
  
}