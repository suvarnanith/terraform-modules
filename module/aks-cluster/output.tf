output "aks-name" {
    value = azurerm_kubernetes_cluster.aks.name
}

output "aks-nodepoolname" {
    value = azurerm_kubernetes_cluster.aks.default_node_pool[0].name
}