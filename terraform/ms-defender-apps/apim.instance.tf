resource "azurerm_api_management" "main" {
  name                = "apim-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"
  sku_name            = "Developer_1"
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/apim.instance.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "25132af0-b0d6-4f03-8041-86ce983c8bbc"
  }
}


resource "azurerm_api_management_logger" "main" {
  name                = "logs"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  resource_id         = azurerm_application_insights.main.id

  application_insights {
    instrumentation_key = azurerm_application_insights.main.instrumentation_key
  }
}
