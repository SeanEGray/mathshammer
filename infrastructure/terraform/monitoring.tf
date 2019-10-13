resource "azurerm_application_insights" "mathshammer" { name                = "mathshammer"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.mathshammer.name}"
    application_type    = "web"
    tags = {
        environment = "${var.environment}"
        application = "mathshammer"
        provisioner = "terraform"
    }
}
