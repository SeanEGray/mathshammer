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
    client_id = "#{terraformClientId}#"
    client_secret = "#{terraformClientSecret}#"
    subscription_id = "#{subscriptionId}#"
    tenant_id = "#{tenantId}#"
}

resource "azurerm_resource_group" "mathshammer" {
    name = "mathshammer${var.environment}"
    location = var.location
    tags = {
        environment = var.environment
        application = "mathshammer"
        provisioner = "terraform"
    }
}
