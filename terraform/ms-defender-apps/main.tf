resource "azurerm_resource_group" "main" {
  name     = "rg-${local.base_name}"
  location = var.location
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/main.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "c857ea18-38f4-46d9-9c51-ec1a288eb5e4"
  }
}

resource "random_string" "main" {
  length  = 4
  special = false
  upper   = false
  numeric = false
  lower   = true
}

data "azurerm_client_config" "current" {}