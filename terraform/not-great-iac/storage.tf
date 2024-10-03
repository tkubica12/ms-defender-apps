resource "azurerm_storage_account" "main" {
  name                            = "mystorageaccount"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  https_traffic_only_enabled      = false
  min_tls_version                 = "TLS1_0"
  public_network_access_enabled   = true
  local_user_enabled              = true
  shared_access_key_enabled       = true
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/not-great-iac/storage.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "98d79f5d-c6cb-4825-855a-00c26ea285ad"
  }
}

resource "azurerm_mssql_server" "main" {
  name                          = "mssqlserver"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12.0"
  administrator_login           = "adminuser"
  administrator_login_password  = "veryGoodPassword123!"
  minimum_tls_version           = "1.0"
  public_network_access_enabled = true
  tags = {
    git_commit           = "e943c0f558fea4bc974665eadcb7861e22de2b6c"
    git_file             = "terraform/not-great-iac/storage.tf"
    git_last_modified_at = "2024-09-30 12:22:21"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "a2ee3a94-5c85-4bc7-ac01-51c20ed3a472"
  }
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}