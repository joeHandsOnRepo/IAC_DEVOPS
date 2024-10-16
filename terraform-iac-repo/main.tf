provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


  
  resource "azurerm_resource_group" "MPIT_RG" {
  name     = var.ResourceGroupName
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
name = "MPIT_VNET"
address_space =   ["10.0.0.0/16"]
location = azurerm_resource_group.MPIT_RG.location
resource_group_name = azurerm_resource_group.MPIT_RG.name
}

resource "azurerm_subnet" "internal" {
  name = "subnet_internal"
  resource_group_name = azurerm_resource_group.MPIT_RG.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.1.0/24"]
  
}

resource "azurerm_network_interface" "main" {
  name = "MPIT_NIC"
  location = azurerm_resource_group.MPIT_RG.location
  resource_group_name = azurerm_resource_group.MPIT_RG.name

  ip_configuration {
    name = "testipconfig"
    subnet_id = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "name" {
  name = "IAC-VM-JOE"
  location = azurerm_resource_group.MPIT_RG.location
  resource_group_name = azurerm_resource_group.MPIT_RG.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  
}

os_profile {
  computer_name = "IAC-VM-JOE"
  admin_username = "joe"
  admin_password = "1234"
}
os_profile_linux_config {
  disable_password_authentication = false
}

tags ={
  envrionment = "dev"
  costcenter = "MPIT"
}
}