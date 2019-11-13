variable "location" {
    type = string
    default = "WestEurope"
}
variable "environment" {
    type = string
    default = "dev"
}
variable "clientid" {
    type = string
    default = "#{terraformClientId}#"
}
variable "clientsecret" {
    type = string
    default = "#{terraformClientSecret}#"
}
variable "tenantid" {
    type = string
    default = "#{tenantId}#"
}
variable "subscriptionid" {
    type = string
    default = "#{subscriptionId}#"
}