terraform {
    backend "remote" {
        organization = "#{backendOrganisation}#"
        token = "#{terraformCloudToken}#"

        workspaces {
            name = "mathshammer"
        }
    }
}

provider "azurerm" {

}

resource "azurerm_resource_group" "mathshammer" {
    name = "mathshammer${var.environment}"
    location = "${var.location}"
    tags = {
        environment = "${var.environment}"
        application = "mathshammer"
        provisioner = "terraform"
    }
}
