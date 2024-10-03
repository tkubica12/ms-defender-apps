resource "azurerm_storage_account" "main" {
  name                            = "st${local.base_name_nodash}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/storage.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "00655647-26a7-47cc-9788-77b36c4b613e"
  }
}
