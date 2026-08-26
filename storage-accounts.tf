module "az-storage_int" {
  source                          = "./module/storage-account"
  environment                     = var.environment
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tags                            = var.tags
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  public_network_access_enabled   = false
  project                         = var.project
  descriptor                      = var.descriptor_for_int

        
}

resource "azurerm_storage_share" "fa_int_storage_share" {
  name               = "internal-${var.environment}-share"
  quota              = 5000
  storage_account_id = module.az-storage_int.id

}



module "az-storage_ext" {
  source                          = "./module/storage-account"
  environment                     = var.environment
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tags                            = var.tags
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  public_network_access_enabled   = false
  project                         = var.project
  descriptor                      = var.descriptor_for_ext
}

  resource "azurerm_storage_share" "fa_ext_storage_share" {
  name               = "external-${var.environment}-share"
  quota              = 5000
  storage_account_id = module.az-storage_ext.id
}



module "az-storage_la" {
  source                          = "./module/storage-account"
  environment                     = var.environment
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tags                            = var.tags
  account_replication_type        = "GZRS"
  account_tier                    = "Standard"
  public_network_access_enabled   = false
  project                         = var.project
  descriptor                      = var.descriptor_for_la
}


resource "azurerm_storage_share" "la_storage_account_share" {
  name               = "${var.project}-${var.appName}-${var.environment}-content"
  quota              = 5000
  storage_account_id = module.az-storage_la.id
}
