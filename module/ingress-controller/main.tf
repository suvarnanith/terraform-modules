data "azurerm_virtual_network" "vnet" {
  name = var.aks_vnet_name
  resource_group_name = var.resource_group_name_aks
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name_aks
}

resource "azurerm_role_assignment" "acrassign" {
  principal_id                     = data.azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                            = data.azurerm_virtual_network.vnet.id
  skip_service_principal_aad_check = true
}


locals {
  ingressname =  "ingress-nginx"
}

resource "null_resource" "akscredentials" {
  provisioner "local-exec" {
    command="az aks get-credentials -g ${var.resource_group_name_aks} -n ${var.aks_name} --overwrite-existing"
  }
}

resource "helm_release" "ingress" {
  depends_on = [ azurerm_role_assignment.acrassign, null_resource.akscredentials ]
  name             = local.ingressname
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  values = [
    file("${path.module}/values.yml")
  ]
}
