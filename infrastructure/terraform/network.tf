resource "azurerm_virtual_network" "mathshammer" {
    name = "mathshammer"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.mathshammer.name}"
    address_space = ["10.0.0.0/16"]
    tags = {
        environment = "${var.environment}"
        application = "mathshammer"
        provisioner = "terraform"
    }
}

resource "azurerm_subnet" "mathshammer" {
    name                 = "mathshammer"
    resource_group_name  = "${azurerm_resource_group.mathshammer.name}"
    virtual_network_name = "${azurerm_virtual_network.mathshammer.name}"
    address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet_network_security_group_association" "mathshammer" {
    subnet_id = "${azurerm_subnet.mathshammer.id}"
    network_security_group_id = "${azurerm_network_security_group.mathshammer.id}"
}

resource "azurerm_network_security_group" "mathshammer" {
    name = "mathshammer"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.mathshammer.name}"
    tags = {
        environment = "${var.environment}"
        application = "mathshammer"
        provisioner = "terraform"
    }
}

# Need to update this when have more details
resource "azurerm_network_security_rule" "frontend_to_backend" {
    name                        = "frontend_to_backed"
    priority                    = 100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${azurerm_resource_group.mathshammer.name}"
    network_security_group_name = "${azurerm_network_security_group.mathshammer.name}"
}
