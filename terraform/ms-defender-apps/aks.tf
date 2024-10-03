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
  tags = {
    git_commit           = "34edf68a6d8a3201c5936a365f6787136d50d2d1"
    git_file             = "terraform/ms-defender-apps/aks.tf"
    git_last_modified_at = "2024-10-03 14:46:35"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "bee870bb-169f-43c8-a7f0-dd8e16f66b1c"
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

