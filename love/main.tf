resource "azurerm_resource_group" "yesrg" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_virtual_network" "vnet" {
  name                ="vnet"
  location            =local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.yesrg
  ]
}

resource "azurerm_subnet" "Subnet" {
  name                 = "Subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = "vnet"
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

