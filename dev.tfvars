
#general
location            = "uksouth"
resource_group_name = "tuns8rgp"
project             = "client"
environment         = "dev"
identity_type       = "SystemAssigned, UserAssigned"



################
# NETWORK-HUB  #
#################
vnet_name             = "client"
vnet_name_for_dns     = "vnet-client-dev"
vnet_address_prefixes = ["10.223.168.0/23", "10.238.185.128/25"]
subnets = [{
  name                              = "endpoints"
  address_prefixes                  = ["10.223.168.0/25"]
  service_endpoints                 = ["Microsoft.Storage", "Microsoft.KeyVault"]
  private_endpoint_network_policies = "Enabled"
  },
  {
    name              = "funct-outbound"
    address_prefixes  = ["10.223.168.128/26"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = {
      enabled                           = true
      actions                           = ["Microsoft.Network/virtualNetworks/subnets/action"]
      service_name                      = "Microsoft.Web/serverFarms"
      private_endpoint_network_policies = "Enabled"
    }
  },
  {
    name              = "lapp-outbound"
    address_prefixes  = ["10.223.168.192/26"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = {
      enabled                           = true
      actions                           = ["Microsoft.Network/virtualNetworks/subnets/action"]
      service_name                      = "Microsoft.Web/serverFarms"
      private_endpoint_network_policies = "Enabled"
    }
  },
  {
    name              = "funct-ext-outbound"
    address_prefixes  = ["10.223.169.0/26"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = {
      enabled                           = true
      actions                           = ["Microsoft.Network/virtualNetworks/subnets/action"]
      service_name                      = "Microsoft.Web/serverFarms"
      private_endpoint_network_policies = "Enabled"
    }
  },
  {
    name              = "powerapps"
    address_prefixes  = ["10.223.169.64/27"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = {
      enabled                           = true
      actions                           = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      service_name                      = "Microsoft.PowerPlatform/enterprisePolicies"
      private_endpoint_network_policies = "Enabled"
    }
  },
  {
    name                              = "general"
    address_prefixes                  = ["10.223.169.96/28"]
    service_endpoints                 = ["Microsoft.Storage", "Microsoft.KeyVault"]
    attach_network_security_group     = false
    private_endpoint_network_policies = "Enabled"
  },
  {
    name                              = "AzureBastionSubnet"
    address_prefixes                  = ["10.223.169.128/26"]
    service_endpoints                 = []
    attach_network_security_group     = false
    private_endpoint_network_policies = "Enabled"
  },


]




private_dns_zones = {
  azure  = "privatelink.monitor.azure.com",
  ops    = "privatelink.oms.opinsights.azure.com",
  ods    = "privatelink.ods.opinsights.azure.com",
  agent  = "privatelink.agentsvc.azure-automation.net",
  webapp = "privatelink.azurewebsites.net",
  kv     = "privatelink.vaultcore.azure.net",
  cog    = "privatelink.cognitiveservices.azure.com",
  ac     = "privatelink.azure-automation.net",
  sql    = "privatelink.database.windows.net",
  adf    = "privatelink.datafactory.azure.net"
}


###################
# NSG             #
###################
inbound_rules = [{
  name                       = "AllowAccessfromVM"
  priority                   = 100
  access                     = "Allow"
  protocol                   = "Tcp"
  source_address_prefix      = "10.223.169.96/28"
  source_port_range          = "*"
  destination_address_prefix = "*"
  destination_port_ranges    = ["443", "80", "1433"]
  description                = "port 443,80 so vm can access azure functions & Logic app"

  },
  {
    name                       = "InterSubnetInBound"
    priority                   = 101
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.223.168.0/25"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    description                = "port 443 so vm can access azure functions & Logic app"
  },
  {
    name                       = "Allow-lapp-outbound-sa"
    priority                   = 103
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.223.168.192/26"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["443", "80", "445"]
    description                = "Logic app to make outbound calls to storage account"
  },
  {
    name                       = "Allow-func-outbound"
    priority                   = 105
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.223.168.128/26"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["443", "80", "445"]
    description                = "Fuction app to make outbound calls to storage account"
  },
  {
    name                       = "Allow-func-ext-outbound"
    priority                   = 106
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "10.223.169.0/26"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["443", "80", "445"]
    description                = "Fuction app to make outbound calls to storage account"
  },
  {
    name                       = "DenyInbound"
    priority                   = 4000
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    description                = "Deny All inbound request"
  }
]



# subnet_cidr_block   = ["10.100.0.0/28", "10.100.0.16/28"]



#function app
use_32_bit_worker                = true
operating_system                 = "Linux"
application_stack_dotnet_version = "8.0"
descriptor_for_ext               = "faexternal"
descriptor_for_int               = "fainternal"
main_app_settings = {
  "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" : 1
  "WEBSITE_CONTENTOVERVNET"  = 1,
  "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
  "apikey"                   = "@Microsoft.KeyVault(SecretUri=https://kep-client-prd.vault.azure.net/secrets/apipwd)"

}

staging_slot_settings = {
  "WEBSITE_CONTENTOVERVNET"  = 1
  "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
  "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" : 1
  "apikey" = "@Microsoft.KeyVault(SecretUri=https://kep-client-prd.vault.azure.net/secrets/apipwd)"

}
allow_nested_items_public_sa_ext = false
allow_network_access_sa_ext      = true
allow_public_access_funct_ext    = true
allow_public_access_funct_int    = true



#logic app
use_32_bit_worker_process = false
allow_public_access_la    = false
appName                   = "migration"
service_plan_os           = "Linux"
descriptor_for_la         = "la"
app_settings = {
  "FUNCTIONS_INPROC_NET8_ENABLED" : "1"
  "WEBSITE_CONTENTOVERVNET" : "1"
  "WEBSITE_NODE_DEFAULT_VERSION" : "~20"
  "LOGIC_APPS_POWERSHELL_VERSION" : "7.4"
  "APPINSIGHTS_PROFILERFEATURE_VERSION" : "1.0.0"
  "APPINSIGHTS_SNAPSHOTFEATURE_VERSION" : "1.0.0"
  "ApplicationInsightsAgent_EXTENSION_VERSION" : "~2"
  "DiagnosticServices_EXTENSION_VERSION" : "~3"
  "InstrumentationEngine_EXTENSION_VERSION" : "~2"
  "SnapshotDebugger_EXTENSION_VERSION" : "1.0.15"
  "XDT_MicrosoftApplicationInsights_BaseExtensions" : "disabled"
  "XDT_MicrosoftApplicationInsights_Mode" : "recommended"
  "apikey" = "@Microsoft.KeyVault(SecretUri=https://kep-client-prd.vault.azure.net/secrets/apipwd)"
}


logic_app_dns = {
  blob  = "privatelink.blob.core.windows.net"
  queue = "privatelink.queue.core.windows.net"
  file  = "privatelink.file.core.windows.net"
  table = "privatelink.table.core.windows.net"
}


#Monitor
main_project     = "sasa"
sub_project      = "client"
application_type = "web"



#baston
bastion_name       = "client-bastion"
bastion_pip_name   = "client-bastionip"
copy_paste_enabled = true
sku                = "Basic"



###################
# VIRUTAL MACHINE #
###################
virtual_machines = [{
  admin_username       = "admin"
  size                 = "Standard_F8s_v2"
  caching              = "None"
  storage_account_type = "Premium_LRS"
  publisher            = "MicrosoftWindowsServer"
  offer                = "WindowsServer"
  sku                  = "2022-datacenter"
  version              = "latest"

}]
machineName                  = "ctcp"
operating_system_use_windows = "windows"



tags = {
  product = "client"
}


