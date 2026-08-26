variable "environment" {
  type        = string
  description = "(Required) This is the environment name where the storage account will be created."

  # TO DO: VALIDATION COMMENTED PENDING ENVIRO NAMING CONVENTION STANDARDISATION
  # validation {
  #   condition     = var.environment == "dev" || var.environment == "npa" || var.environment == "stg" || var.environment == "prod"
  #   error_message = "Invalid environment name. Should be one of these - dev, npa, prod, stg"
  # }
}

variable "project" {
  type        = string
  description = "(Required) project name (lowercase letters and numbers only)"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.project))
    error_message = "project must be lowercase letters and numbers only."
  }
}

variable "descriptor" {
  type        = string
  default     = ""
  description = "(Optional) Additional descriptor to use in account name for uniqueness or making multiple accounts within the same project unique. (lowercase letters and numbers only)"

  validation {
    condition     = can(regex("^[a-z0-9]*$", var.descriptor))
    error_message = "descriptor must be lowercase letters and numbers only."
  }
}

variable "add_random_name_suffix" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not to pad the end of the storage account with random characters to ensure uniqueness."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the storage account will be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Storage Account should exist. Changing this forces a new Storage Account to be created."
}

variable "account_kind" {
  type        = string
  description = "(Optional) Kind of storage account to create."
  default     = "StorageV2"

  validation {
    condition     = contains(["StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.account_kind)
    error_message = "Invalid account kind, should be one of 'StorageV2', 'BlobStorage', 'BlockBlobStorage', 'FileStorage'."
  }
}

variable "account_tier" {
  type        = string
  description = "(Optional) The tier of the storage account. Options: Standard, Premium."

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Invalid account tier, must be 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  type        = string
  description = "(Required) The replication type for the storage account. Options: LRS, GRS, RA-GRS, etc."

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Invalid account tier, must be 'Standard' or 'Premium'."
  }
}

variable "access_tier" {
  type        = string
  description = "(Optional) Access tier for the storage account. Must be one of 'Hot', 'Cool', 'Cold' or 'Premium'."
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool", "Cold", "Premium"], var.access_tier)
    error_message = "Invalid access tier, must be 'Hot', 'Cool', 'Cold' or 'Premium'."
  }
}

variable "https_only" {
  type        = bool
  description = "(Optional) Whether or not only HTTPS traffic should be allowed to the account."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "(Optional) Minimum TLS version allowed to be used when connecting to the account."
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether or not public network access should be enabled. Disabled by default, private endpoints should be used unless non-vnet access is explicitly required."
  default     = false
}

variable "public_access_default_action" {
  type        = string
  description = "(Optional) Default action for unmatched IP rules when public network access is enabled. Allowed values are 'Allow', 'Deny'."
  default     = "Deny"
  validation {
    condition     = contains(["Deny", "Allow"], var.public_access_default_action)
    error_message = "Invalid action, must be 'Deny'/'Allow'."
  }
}

variable "public_access_bypass" {
  type        = list(string)
  description = "(Optional) Whether traffic can be bypassed for logging/metrics/Azure services. May be any combination of `Logging`, `Metrics`, `AzureServices` or `None`."
  default     = ["AzureServices"]
}

variable "public_access_ip_rules" {
  type        = list(string)
  description = "(Optional) List of IP addresses or CIDRs to allow access to the storage account if public access is enabled."
  default     = []
}

variable "static_website" {
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  description = "(Optional) Provides options for using a storage account to host a static website."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the Storage Account."
  default     = {}
}
