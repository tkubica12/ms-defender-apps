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
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/ms-defender-apps/capp.books.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "books"
    yor_trace            = "a78c7f05-8408-4863-a8b2-9686a5842d95"
  }
}
