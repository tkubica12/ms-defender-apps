resource "azurerm_container_registry" "main" {
  name                = "acr${local.base_name_nodash}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/ms-defender-apps/acr.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "21221887-7ce7-4673-940c-8296c494dcd0"
  }
}



resource "azurerm_resource_deployment_script_azure_cli" "import_images" {
  name                = "import_images"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  version             = "2.47.0"
  retention_interval  = "P1D"
  cleanup_preference  = "OnSuccess"

  script_content = <<EOF
az acr import --name ${azurerm_container_registry.main.name} --source docker.io/library/nginx:1.22.0 --image nginx:1.22.0 --force
az acr import --name ${azurerm_container_registry.main.name} --source docker.io/alfredodeza/vulnerable:latest --image vulnerable:latest --force
EOF

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.deployment.id
    ]
  }

  depends_on = [
    azurerm_role_assignment.acr_deployment
  ]
  tags = {
    git_commit           = "34edf68a6d8a3201c5936a365f6787136d50d2d1"
    git_file             = "terraform/ms-defender-apps/acr.tf"
    git_last_modified_at = "2024-10-03 14:46:35"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "import_images"
    yor_trace            = "44ccf9b2-4a1a-4ae1-ab91-d5e5cc2fb2d8"
  }
}
