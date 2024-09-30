resource "azurerm_container_app" "books" {
  name                         = "ca-books"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    min_replicas = 0

    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/ms-defender-apps/books:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "COSMOS_ENDPOINT"
        value = azurerm_cosmosdb_account.main.endpoint
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.main.client_id
      }
    }
  }

  ingress {
    target_port      = 8000
    external_enabled = true

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }
}
