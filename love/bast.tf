resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = "vnet"
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
resource "azurerm_public_ip" "appip" {
  name                = "appip"
  resource_group_name = local.resource_group_name
  location            =local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.yesrg
  ]
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.appip.id
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


resource "azurerm_network_interface" "appface" {
  name                = "appface-nci"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet.id
    private_ip_address_allocation = "Dynamic"

  }

  depends_on = [
    azurerm_resource_group.yesrg
  ]
}

resource "azurerm_windows_virtual_machine" "appvm" {
  name                = "appvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@ssword1234!"
  network_interface_ids = [
    azurerm_network_interface.appface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

