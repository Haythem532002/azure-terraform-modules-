resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "mapp-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_name         = "myapp-subnet"
  subnet_prefixes     = ["10.0.1.0/24"]
  nsg_name            = "myapp-nsg"
}


module "vm" {
  source              = "./modules/vm"
  public_ip_name      = "myapp-public-ip-name"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  nic_name            = "myapp-nic"
  vm_size             = "Standard_B2ats_v2"
  vm_name             = "myapp-vm"
  admin_username      = var.admin_username
  subnet_id           = module.network.subnet_id
  ssh_public_key_path = file(var.ssh_public_key_path)

}