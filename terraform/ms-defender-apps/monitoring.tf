resource "azurerm_log_analytics_workspace" "main" {
  name                = "logs-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/monitoring.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "cef21b7c-baac-4d2a-aedf-b6ce2c00c121"
  }
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/monitoring.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "04e2d851-aeea-4f23-8ced-425db3211778"
  }
}
