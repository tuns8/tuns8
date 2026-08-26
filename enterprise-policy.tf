resource "azurerm_resource_group_template_deployment" "enterprise_policy" {
depends_on = [terraform_data.subnet_ready]
  name                = "deploy-pp-enterprise-policy-${random_integer.amp_id.result}-${var.environment}"

  resource_group_name = var.resource_group_name

  deployment_mode     = "Incremental"


  parameters_content = jsonencode({

    policyName = {

      value = "ep-${var.project}-${var.environment}"

    }

    powerplatformEnvironmentRegion = {

      value = "uk"

    }

    vNetOneSubnetName = {

      value = "powerapps"

    }

    vNetOneResourceId = {

      value = module.network-hub.vnet_id

    }

    vNetTwoSubnetName = {

      value = "powerapps"

    }

    vNetTwoResourceId = {

      value = azurerm_virtual_network.vnetukwest.id

    }

  })

  template_content = file("${path.module}/files/enterprise-policy.json")

lifecycle {
  ignore_changes = [template_content] #comment this out only if you made changes to the powershell script located in /files/keyrotation-runbook.ps1
 }

}


resource "azurerm_virtual_network" "vnetukwest" {
  name                = "vnet-tuns8test"
  resource_group_name = var.resource_group_name
  location            = "ukwest"
  address_space       = ["10.0.0.0/23"]

}

resource "azurerm_virtual_network_peering" "vnetregionb-regiona" {
  depends_on                = [azurerm_virtual_network.vnetukwest]
  name                      = "${azurerm_virtual_network.vnetukwest.name}-to-${module.network-hub.name}-peering"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = "vnet-tuns8test"
  remote_virtual_network_id = module.network-hub.vnet_id
  use_remote_gateways       = false
  allow_forwarded_traffic   = true

}

resource "azurerm_virtual_network_peering" "vnetregiona-regionb" {
  name                      = "${module.network-hub.name}-to-${azurerm_virtual_network.vnetukwest.name}-peering"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.network-hub.name
  remote_virtual_network_id = azurerm_virtual_network.vnetukwest.id
  allow_forwarded_traffic   = true

}

resource "azurerm_subnet" "subnetsukw" {

  name                 = "powerapps"
  virtual_network_name = azurerm_virtual_network.vnetukwest.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.0.0.0/27"]
  delegation {
    name = "powerapps"
    service_delegation {
  name = "Microsoft.PowerPlatform/enterprisePolicies"
  actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }

  }

}