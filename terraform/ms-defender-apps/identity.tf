resource "azurerm_user_assigned_identity" "main" {
  name                = "services-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/ms-defender-apps/identity.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "8355175f-c260-4898-b59e-aab3e2de5356"
  }
}

resource "azurerm_user_assigned_identity" "deployment" {
  name                = "deployment-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/ms-defender-apps/identity.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "deployment"
    yor_trace            = "89fe57e3-8b86-4889-8942-01394d748b83"
  }
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = {
    git_commit           = "34edf68a6d8a3201c5936a365f6787136d50d2d1"
    git_file             = "terraform/ms-defender-apps/identity.tf"
    git_last_modified_at = "2024-10-03 14:46:35"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "aks"
    yor_trace            = "91827758-b42b-4cac-af84-34f0f2988504"
  }
}
