resource "azurerm_storage_account" "web" {
  name                      = "mathshammerdevweb"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.mathshammer.name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  # custom_domain = "mathshammer.bigyak.io"

  tags = {
    environment = "${var.environment}"
    application = "mathshammer"
    provisioner = "terraform"
  }
}

resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_name  = "${azurerm_storage_account.web.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "indexhtml" {
  name                   = "index.html"
  storage_account_name   = "${azurerm_storage_account.web.name}"
  storage_container_name = "${azurerm_storage_container.web.name}"
  type                   = "Block"
  source                 = "index.html"
  content_type           = "text/html"
}
