variable "location" {
}

variable "resource_group_name" {
}

variable "tags" {
  description = "tags to apply to resources created by this module"
  type        = map(any)
}

variable "key_vault_soft_delete_retention_days" {
  description = "Amount of days key vault will be soft deleted for"
  type        = number
  default     = 7
}

variable "project" {
  type = string
  description = "(Required)String. Project name."
}

variable "environment" {
  type = string
  description = "(Required)String. Environment name."
}

variable "identifier" {
  type = string
  default = null
  description = "(Optional)String. Identifier for multiple project key vaults."
}

variable "public_network_access_enabled" {
  type = bool
  default = "true"
  description = "(Optional)Bool. Public network access enabled. Defaults to true."

  validation {
    condition     =  can(regex("^(true|false)$", var.public_network_access_enabled)) 
    error_message = "Possible values are 'true' or 'false'."
  }
}

variable "allow_azure_vm_secret_retrieval" {
  type = bool
  default = "false"
  description = "(Optional)Bool. Allow Azure Virtual Machines to retrieve certificates stored as secrets from the key vault"

  validation {
    condition     =  can(regex("^(true|false)$", var.allow_azure_vm_secret_retrieval)) 
    error_message = "Possible values are 'true' or 'false'."
  }
}

variable "allow_azure_disk_encryption_secret_retrieval" {
  type = bool
  default = "false"
  description = "(Optional)Bool. Allow Azure Disk Encryption to retrieve secrets from the key vault"

  validation {
    condition     =  can(regex("^(true|false)$", var.allow_azure_disk_encryption_secret_retrieval)) 
    error_message = "Possible values are 'true' or 'false'."
  }
}

variable "allow_arm_secret_retrieval" {
  type = bool
  default = "false"
  description = "(Optional)Bool. Allow Azure Resource Manager to retrieve secrets from the key vault"

  validation {
    condition     =  can(regex("^(true|false)$", var.allow_arm_secret_retrieval)) 
    error_message = "Possible values are 'true' or 'false'."
  }
}
variable "nacls_bypass" {
  type = string
  default = "AzureServices"
  description = "(Optional)String. Which traffic can bypass the network rules. Possible values are 'AzureServices' and 'None'. Defaults to 'AzureServices'."

  validation {
    condition     =  can(regex("^(AzureServices|None)$", var.nacls_bypass)) 
    error_message = "Possible values are 'true' or 'false'."
  }
}

variable "nacls_default_action" {
  type = string
  default = "Allow"
  description = "(Optional)String. The Default Action to use when no rules match from nacls ip rules and nacls subnet rules. Possible values are 'Allow' and 'Deny'. Defaults to 'Deny'. In preprod/prod environments this is always 'Deny'."

  validation {
    condition     =  can(regex("^(Allow|Deny)$", var.nacls_default_action)) 
    error_message = "Possible values are 'Allow' or 'Deny'."
  }

}

variable "allowed_ips" {
  type = list(string)
  default = [ "52.56.62.128/25" ]
  description = "(Optional)List. List of whitelisted IPs allowed to access the key vault. If restricting incoming traffic nacls_default_action should be set to 'Deny'. Defaults to the POISE network CIDR range"
}

variable "subnet_ids" {
  type = list(string)
  default = null
  description = "(Optional)List. List of subnet IDs allowed to access the key vault. If restricting incoming traffic nacls_default_action should be set to 'Deny'. "
}