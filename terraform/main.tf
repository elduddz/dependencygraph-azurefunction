data "azurerm_resource_group" "rg" {
    name = "dependencygraph-rg"
}
resource "azurerm_storage_account" "sa" {
  name                     = "depdencygraphsa"
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${data.azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "sp" {
  name                = "azure-functions-service-plan"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "fa" {
  name                      = "${var.function_app_name}"
  location                  = "${data.azurerm_resource_group.rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.sp.id}"
  storage_connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
}