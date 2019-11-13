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

  provisioner "local-exec" {
    command = "az login  --service-principal -u \"${var.armclientid}\" -p \"${var.armclientsecret}\" --tenant \"${var.armtenantid}\" | az storage blob service-properties update --account-name ${azurerm_storage_account.web.name} --static-website  --index-document index.html --404-document 404.html"
  }
}

resource "azurerm_storage_blob" "indexhtml" {
  name                   = "index.html"
  storage_account_name   = "${azurerm_storage_account.web.name}"
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "index.html"
  content_type           = "text/html"
}
