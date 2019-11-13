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
    client_id = "${var.clientid}"
    client_secret = "${var.clientsecret}"
    subscription_id = "${var.subscriptionid}"
    tenant_id = "${var.tenantid}"
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
