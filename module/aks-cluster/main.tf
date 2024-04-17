data "azurerm_resource_group" "rg" {
  name = var.resource_group_name_aks
  #location = var.location
}

data "azurerm_subnet" "akssubnet" {
  name = var.aks_subnet_name
  resource_group_name = var.resource_group_name_aks
  virtual_network_name = var.aks_vnet_name
}

data "azurerm_kubernetes_service_versions" "current" {
  location = data.azurerm_resource_group.rg.location
  include_preview = false  
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_name}-k8s"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version 

  network_profile {
    dns_service_ip = var.dnsserviceip
    service_cidr = var.servicecidr
    load_balancer_sku = var.loadbalancersku
    network_policy = var.networkpolicy
    network_plugin = var.plugin
    network_plugin_mode = var.pluginmode
    pod_cidr = var.podcidr
  }

  default_node_pool {
    name            = var.nodepoolname
    vm_size         = var.nodepoolsize
    zones = var.zone
    os_disk_size_gb = var.osdisksize
    vnet_subnet_id = data.azurerm_subnet.akssubnet.id
    enable_auto_scaling = var.enableauto
    type = var.vmsstype
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_type = var.disktype
    max_count = 2
    min_count = 1
    node_count = 1
    node_labels = {
      "env" = "dev"
    }

  }
  identity {
    type = "SystemAssigned"
  }

  tags = {
    "Resource Name" = "AKS-Cluster"
    "Environment" = var.environment
  }
}

