# вивести в окремий файл terraform_requirenmets
terraform {
    required_version = ">=0.12" 
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

}

resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

data "azurerm_virtual_network" "ykedvnet314" {
  name                = var.virtual_network
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
}
/*
resource "azurerm_virtual_network" "vnet" {
  name                = lower(join("-",["vnet",var.app_name]))
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
}
*/
resource "azurerm_public_ip" "pip" {
 name                         = lower(join("-",["pub-ip",var.app_name])) # "vmss-public-ip"
 location                     = var.location
 resource_group_name          = var.resource_group_name
 allocation_method            = "Static"
 domain_name_label            = random_string.fqdn.result
 tags                         = var.tags
}

data "azurerm_resource_group" "image" {
  name                = var.resource_group_name
}

data "azurerm_image" "image" {
  name                = var.image_name
  resource_group_name = data.azurerm_resource_group.image.name
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
 name                = lower(join("-",["vmss",var.app_name]))
 location            = var.location
 resource_group_name = var.resource_group_name
 upgrade_policy_mode = "Manual"
 
 
 sku {
   name     = "Standard_B1ms"
   tier     = "Standard"
   capacity = 1
 }


  storage_profile_image_reference {
    id=data.azurerm_image.image.id
  }

 storage_profile_os_disk {
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"

 }

 os_profile {
   computer_name_prefix = lower(join("-",["os-profile",var.app_name]))
   admin_username       = var.admin_user
   admin_password       = var.admin_password
     
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = lower(join("-",["netinterfaceconf",var.app_name]))
   primary = true

   ip_configuration {
     name        = lower(join("-",["IP",var.app_name]))  #"IPConfiguration"
     subnet_id   = azurerm_subnet.myesubnet.id
     primary = true
   }
 }

 tags = var.tags

 depends_on = [azurerm_mysql_flexible_database.eschool]
}
