resource "azurerm_container_registry" "main" {
  name                = "acr${local.base_name_nodash}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}



resource "azurerm_resource_deployment_script_azure_cli" "import_images" {
  name                = "import_images"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  version             = "2.47.0"
  retention_interval  = "P1D"
  cleanup_preference  = "OnSuccess"

  script_content = <<EOF
az acr import --name ${azurerm_container_registry.main.name} --source docker.io/library/nginx:1.7.11 --image nginx:1.7.11
az acr import --name ${azurerm_container_registry.main.name} --source docker.io/alfredodeza/vulnerable:latest --image vulnerable:latest
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
}
