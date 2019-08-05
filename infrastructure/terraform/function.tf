# function app
# storage?
# web page
# some kind of hostname / dns thing?


resource "random_id" "storagename" {
  byte_length = 8
  prefix      = "mh"
}

resource "azurerm_storage_account" "mathshammer" {
  name                       = "${random_id.storagename.hex}"
  resource_group_name        = "${azurerm_resource_group.mathshammer.name}"
  location                   = "${var.location}"
  account_kind               = "StorageV2"
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  enable_https_traffic_only  = true
  tags = {
    environment = "${var.environment}"
    application = "mathshammer"
    provisioner = "terraform"
  }
}

resource "azurerm_app_service_plan" "mathshammer" {
  name                = "mathshammer"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.mathshammer.name}"
  kind                = "FunctionApp"
  sku = {
    tier = "Dynamic"
    size = "Y1"
  }
  tags = {
    environment = "${var.environment}"
    application = "mathshammer"
    provisioner = "terraform"
  }
}

resource "azurerm_function_app" "mathshammer" {
  name                        = "mathshammer"
  resource_group_name         = "${azurerm_resource_group.mathshammer.name}"
  location                    = "${var.location}"
  app_service_plan_id         = "${azurerm_app_service_plan.mathshammer.id}"
  storage_connection_string   = "${azurerm_storage_account.mathshammer.primary_connection_string}"
  https_only                  = true
  version                     = "~2"
  use_32_bit_worker_processes = false
  tags = {
    environment = "${var.environment}"
    application = "mathshammer"
    provisioner = "terraform"
  }
}
