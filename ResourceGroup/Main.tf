provider "azurerm" {
features{}
# subscriptionId =""
#Client_ID =""
#Client_Secret ="value"
#Tenant_ID ="value"
}

resource "azurerm_resource_group" "Test01" {
  count    = 2
  name     = var.name[count.index]
  location = "${var.location}"
#tags = var.tags
}