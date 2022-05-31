/*module "rg" {

  source = "./module/ResourceGroup"
}*/

module "vm" {

  source = "../module/nsg"
  
}





/*resource "azurerm_resource_group" "Test01" {
  count    = 2
  name     = var.name[count.index]
  location = "${var.location}"
#tags = var.tags
}

resource "azurerm_resource_group" "Test02" {
  name     = "Demo02"
location = var.location
#tags = var.tags1
}

resource "azurerm_resource_group" "Test03" {
  name     = "Demo03"
location = var.location1
tags = var.tags1
}*/