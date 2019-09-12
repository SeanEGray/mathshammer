terraform {
    backend "remote" {
        organization = "#{backendOrganisation}#"

        workspaces {
            prefix = "mathshammer"
            token = "#{terraformCloudToken}#"
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
