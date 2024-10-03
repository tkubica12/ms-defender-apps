resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-${local.base_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks.id
    ]
  }
  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings
    ]
  }
}

resource "helm_release" "api_attacks" {
  name             = "api-attacks"
  chart            = "../../charts/api_attacks"
  namespace        = defender-demo
  create_namespace = true
}

resource "helm_release" "runtime_attacks" {
  name             = "runtime-attacks"
  chart            = "../../charts/runtime_attacks"
  namespace        = defender-demo
  create_namespace = true
}

