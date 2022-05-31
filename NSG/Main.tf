provider "azurerm" {
features{}
}

resource "azurerm_resource_group" "example" {
  name     = var.name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "testvnet"
  address_space       = ["10.0.0.0/16"]
  #location            = "${arzurerm_resource_group.example.location}"
  #resource_group_name = "${azurerm_resource_group.example.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "azsubnet" {
   # count = 3
  name                 = "subnetforvm"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
    count=2
      name                = "vmnic${count.index}"
 # location            = "${arzurerm_resource_group.example.location}"
  #resource_group_name = "${azurerm_resource_group.example.name}"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    
    name                          = "testip"
    subnet_id                     = "${azurerm_subnet.azsubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_security_group" "testnsg" {
  name                = "testnsg1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

 security_rule {
    name                       = "test123"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
  resource "azurerm_subnet_network_security_group_association" "nsgattach" {
  subnet_id                 = azurerm_subnet.azsubnet.id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}

resource "azurerm_network_interface_security_group_association" "example" {
  count = 2
  network_interface_id      = element(azurerm_network_interface.nic.*.id,count.index)
    network_security_group_id = azurerm_network_security_group.testnsg.id
}

#################################################################################################
#Additional Nic card for testing
/*resource "azurerm_network_interface" "nic1" {
    count=1
  name                = "vmnic1${count.index}"
 # location            = "${arzurerm_resource_group.example.location}"
  #resource_group_name = "${azurerm_resource_group.example.name}"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    
    name                          = "testip"
    subnet_id                     = "${azurerm_subnet.azsubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}*/

########################################################################################################


resource "azurerm_virtual_machine" "main" {
 count = 2
  name                  = "testvm${count.index}"
 # location              = "${arzurerm_resource_group.example.location}"
  #resource_group_name   = "${azurerm_resource_group.example.name}"
  location            = var.location
  resource_group_name = var.name
  network_interface_ids = [ element(azurerm_network_interface.nic.*.id,count.index)]
  #network_interface_ids =  azurerm_network_security_group.testnsg.id
    vm_size               = "Standard_D2as_v4"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.osdisk[count.index]
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    

  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}