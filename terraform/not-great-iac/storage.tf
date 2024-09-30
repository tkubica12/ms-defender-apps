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
}

resource "azurerm_mssql_server" "main" {
  name                         = "mssqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "veryGoodPassword123!"
  minimum_tls_version          = "1.0"
  public_network_access_enabled = true
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}