module "az-ngw" {
  source = "./module/Nat-Gateway"
  environment = var.environment
  location = var.location
  resource_group_name = var.resource_group_name
  project = var.project
}


resource "azurerm_subnet_nat_gateway_association" "ng_logic_app" {
  subnet_id      = module.network-hub.subnet_ids["lapp-outbound"]
  nat_gateway_id = module.az-ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "ng_funct_app" {
  subnet_id      = module.network-hub.subnet_ids["funct-outbound"]
  nat_gateway_id = module.az-ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "ng_functext_app" {
  subnet_id      = module.network-hub.subnet_ids["funct-ext-outbound"]
  nat_gateway_id = module.az-ngw.id
}