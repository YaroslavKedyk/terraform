resource "azurerm_subnet" "myesubnet" {
  name                 = lower(join("-",["sub-net",var.app_name]))
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ykedvnet314.name
  address_prefixes     = [var.address_prefixes]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
   
  depends_on = [azurerm_virtual_network.ykedvnet314]
}

resource "azurerm_private_dns_zone" "dnsz" {
  name                = lower(join(".",[join("-",["dnsz",var.app_name]),"private.mysql.database.azure.com"])) #myeschooldb3.private.mysql.database.azure.com
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "ykedvnet3143" {
  name                  = azurerm_virtual_network.ykedvnet314.name 
  private_dns_zone_name = azurerm_private_dns_zone.dnsz.name
  virtual_network_id    = azurerm_virtual_network.ykedvnet314.id
  resource_group_name = var.resource_group_name
}

resource "azurerm_mysql_flexible_server" "myeschooldb" {
  name                   = lower(join("-",["db",var.app_name]))
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_db_user
  administrator_password = var.admin_db_password 
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.myesubnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.dnsz.id
  sku_name               = var.sku_name

  depends_on = [azurerm_private_dns_zone_virtual_network_link.ykedvnet3143, azurerm_subnet.myesubnet]
}
    
    resource "azurerm_mysql_flexible_database" "eschool" {
    name                = var.db_name
    resource_group_name = var.resource_group_name
    server_name         = azurerm_mysql_flexible_server.myeschooldb.name
    charset             = "utf8"
    collation           = "utf8_unicode_ci"
    
    depends_on = [azurerm_mysql_flexible_server.myeschooldb]
    }
    