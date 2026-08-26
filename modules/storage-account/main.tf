locals {
  account_base_name = "st${var.project}${var.descriptor}${var.environment}"
  account_full_name = "${local.account_base_name}${var.add_random_name_suffix ? random_string.id[0].result : ""}"
}

resource "random_string" "id" {
  count = var.add_random_name_suffix ? 1 : 0

  length  = 24 - length(local.account_base_name)
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  name                = local.account_full_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  allow_nested_items_to_be_public = false

  https_traffic_only_enabled    = var.https_only
  min_tls_version               = var.min_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  network_rules {
    bypass         = var.public_access_bypass
    default_action = var.public_access_default_action

    ip_rules = var.public_access_ip_rules
  }

  dynamic "static_website" {
    for_each = var.static_website != {} ? { "static_website" = var.static_website } : {}
    content {
      index_document     = static_website.value["index_document"]
      error_404_document = static_website.value["error_404_document"]
    }
  }

  tags = var.tags
}
