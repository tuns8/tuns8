
variable "environment" {
  type        = string
  description = "(Required) custom variable. This is the environment name where the resource group will be created."

  # TO DO: VALIDATION COMMENTED PENDING ENVIRO NAMING CONVENTION STANDARDISATION
  # validation {
  #   condition     = var.environment == "dev" || var.environment == "test" || var.environment == "preprod" || var.environment == "prod"
  #   error_message = "Invalid environment name. Should be one of these - dev, test, preprod, prod"
  # }
}

variable "appName" {
  type        = string
  description = "(Required) custom variable. App name"

}

variable "operating_system" {
  type        = string
  description = "(Optional) OS Type for the function app"
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.operating_system)
    error_message = "Invalid OS Type, must be either 'linux' or 'windows'"
  }
}

variable "resource_group_name" {
  type        = string
  description = "(Required) custom variable. Resource Group Name"
}

variable "subnet_id" {
  type        = string
  description = "(Required) custom variable. Network subnet id"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the Resource Group"
  default     = {}
}

variable "site_config" {
  type        = map(string)
  description = "(Optional) A mapping of site config options"
  default     = {}
}

variable "insights_app_type" {
  type        = string
  default     = "web"
  description = "(Optional) Application Insights App type. Defaults to web"
}

variable "main_app_settings" {
  type        = map(string)
  description = "(Optional) Settings for the function app"
  default     = {}
}

variable "staging_slot_settings" {
  type        = map(string)
  description = "(Optional) Settings for staging slot. If not used, main_app_settings will be applied"
  default     = {}
}

variable "sticky_app_settings" {
  type        = list(string)
  default     = []
  description = "(Optional) List of App Settings that should not be swaped between slots"
}

variable "sticky_connection_strings" {
  type        = list(string)
  default     = []
  description = "(Optional) List of Connection strings that should not be swaped between slots"
}

variable "ip_restrictions" {
  description = "(Optional) List of IP restrictions to apply to Function App"
  type = list(object({
    action      = optional(string)
    name        = optional(string)
    ip_address  = optional(string)
    priority    = optional(number)
    service_tag = optional(string)
  }))
  default = [{
    action     = "Deny"
    name       = "Default"
    ip_address = "0.0.0.0/0"
  }]
}

variable "application_stack_dotnet_version" {
  type        = string
  description = "(Optional) DotNet version. Possible values are; 3.1, 6.0, 7.0, 8.0"
  default     = null
}

variable "application_stack_use_dotnet_isolated_runtime" {
  type        = bool
  description = "(Optional) Should dotnet proccess use an isolated runtime? Defaults to False "
  default     = false
}

variable "application_stack_java_version" {
  type        = string
  description = "(Optional) Java version. Possible values are; 8, 11, 17"
  default     = null
}

variable "application_stack_node_version" {
  type        = string
  description = "(Optional) Node version. Possible values are; 12, 14, 16, 18, 20"
  default     = null
}

variable "application_stack_python_version" {
  type        = string
  description = "(Optional) Python version, Only Supported with Linux Function Apps. Possible values are 3.12, 3.11, 3.10, 3.9, 3.8 and 3.7."
  default     = null
}

variable "application_stack_powershell_core_version" {
  type        = string
  description = "(Optional) Powershell core version. Possibles values are 7 , 7.2, and 7.4. "
  default     = null
}

variable "application_insights_connection_string" {
  type        = string
  description = "(Optional) Connection string for Application Insights"
  default     = null
  sensitive   = true
}

variable "application_insights_instrumentation_key" {
  type        = string
  description = "(Optional) Instrumentation Key for Connecting Application Insights to Function App"
  default     = null
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU name for the app service plan"
  default     = "EP1"
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the Function app should exist. changing this forces a new Resource Group to be created"
  default     = "uksouth"
 
}

variable "use_existing_storage_account" {
  type        = bool
  default     = false
  description = "(Optional) Flag used to set if the module should use an existing storage account. Defaults to false"
}

variable "storage_account_name" {
  type        = string
  description = "(Optional) Name of existing storage account. Storage account generate if not set."
  default     = null
}

variable "storage_access_key" {
  type        = string
  description = "(Optional) Storage account access key if using an already generated resource"
  default     = ""
  sensitive   = true
}

variable "storage_account_id" {
  type        = string
  description = "(Optional) Name of existing storage account. Storage account generate if not set."
  default     = ""
}
variable "use_existing_service_plan" {
  type        = bool
  default     = false
  description = "(Optional) Flag used to set if the module should use an existing service plan. Defaults to false"
}

variable "service_plan_id" {
  type        = string
  description = "(Optional) Id of exiting service plan. Service plan generated if not set."
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "(Optional) Key vault ID. Only Applicable if Storage account name is not set and will be used to store storage account connection key."
  default     = null
}


variable "public_network_access" {
  type        = bool
  description = "(Optional) Whether Public Network Access should be enabled or not. Defaults to false"
  
}

variable "use_32_bit_worker" {
  type        = bool
  description = "(Optional) Should the function App run in 32 bit mode, rather than 64 bit mode? Defaults to true. When using app service plan in the Free or Shared Tiers use_32_bit_worker_process must be true"
  default     = true
}

variable "storage_connection_string" {
  type = string
  default = ""
}

variable "identity_type" {
  type        = string
  description = "(Optional) Managed Identity type. Allowed: SystemAssigned, UserAssigned, 'SystemAssigned, UserAssigned'."
  default     = "SystemAssigned"
  validation {
    condition = contains(
      [null, "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"],
      var.identity_type
    )
    error_message = "Invalid identity_type. Allowed: SystemAssigned, UserAssigned, 'SystemAssigned, UserAssigned'."

  }
}

 

variable "identity_ids" {
  type        = list(string)
  description = "(Optional) List of identity IDs to assign to the app if `identity_type` includes 'UserAssigned'."
  default     = []

}

variable "key_vault_reference_identity_id" {
  type = string
  description = "The User Assigned Identity to use for Key Vault access."
  default = null
  
}

variable "elastic_instance_minimum" {
  type        = number
  description = "(Optional) The number of minimum instances for this Logic App Only affects apps on the Premium plan."
  default     = null
}

variable "maximum_elastic_worker_count" {
  type = number
  default = null
}