variable "resource_group_name" {
   description = "Name of the resource group in which the resources will be created"
   default     = "yked"
}

variable "location" {
   default = "eastus2"
   description = "Location where resources will be created"
}

variable "sku_name" {
   default = "B_Standard_B1ms"
   description = "Name and size of server wich will be created"
}
variable "virtual_network" {
   default = "ykedvnet314"
   description = "VNET name wich are allredy created"
}

variable "tags" {
   description = "Map of the tags to use for the resources that are deployed"
   type        = map(string)
   default = {
      environment = "kedyk.yaroslav"
   }

}
variable "app_name" {
   description = "Name of the application which will be created"
   default     = "eschool"
}

variable "db_name" {
   description = "Name of the database which will be created"
   default     = "eschool"
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "arootuser"
}

variable "admin_password" {
   description = "Default password for admin account"
   
}

variable "admin_db_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "eschool"
}

variable "admin_db_password" {
   description = "Default password for database"
}

variable "address_space" {
   description = "IP adress of VNET for the resources that are deployed"
   default = "10.0.0.0/16"
}

variable "address_prefixes" {
   description = "IP adress of mysubnet for the resources that are deployed"
   default = "10.0.1.0/24"
}

variable "image_name" {
   description = "Name of the image"
   default     = "eschoo1-image"
}