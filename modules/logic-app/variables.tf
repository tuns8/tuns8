
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

variable "project" {
  type        = string
  description = "(Required) project name."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) custom variable. Resource Group Name"
}

variable "subnet_id" {
  type        = string
  description = "(Required) custom variable. Network subnet id"
}

variable "service_plan_os" {
  type        = string
  description = "(Optional) service plan operating system for the logic app. Defaults to Windows. Possible values are `Windows` or `Linux`"
  default     = "Windows"

  validation {
    condition     = var.service_plan_os == "Windows" || var.service_plan_os == "Linux"
    error_message = "Invalid service plan os name. Possible values are `Windows` or `Linux`"
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the Resource Group"
  default     = {}
}

variable "app_settings" {
  type        = map(string)
  description = "(Optional) Settings for the logic app"
  default     = {}
}

variable "ip_restrictions" {
  description = "(Optional) List of IP restrictions to apply to logic App"
  type = list(object({
    action                    = optional(string)
    name                      = optional(string)
    ip_address                = optional(string)
    priority                  = optional(number)
    virtual_network_subnet_id = optional(string)
    service_tag               = optional(string)
  }))
  default = [{
    action     = "Deny"
    name       = "Default"
    ip_address = "0.0.0.0/0"
    priority   = 65000
  }]
}

variable "scm_ip_restrictions" {
  description = "(Optional) List of SCM IP restrictions to apply to logic App"
  type = list(object({
    action                    = optional(string)
    name                      = optional(string)
    ip_address                = optional(string)
    priority                  = optional(number)
    virtual_network_subnet_id = optional(string)
    service_tag               = optional(string)
  }))
  default = [{
    action     = "Deny"
    name       = "Default"
    ip_address = "0.0.0.0/0"
    priority   = 65000
  }]
}

variable "client_affinity" {
  type        = bool
  default     = false
  description = "(Optional) Should the Logic App send session affinity cookies, which route client requests in the same session to the same instance? Defaults to false"
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU name for the app service plan. Defaults to WS1"
  default     = "WS1"
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the logic app should exist. changing this forces a new Resource Group to be created"
  default     = "uksouth"
 
}

variable "storage_account_name" {
  type        = string
  description = "(Optional) Name of existing storage account. Storage account generate if not set."
  default     = ""
}

variable "storage_account_id" {
  type        = string
  description = "(Optional) Name of existing storage account. Storage account generate if not set."
  default     = ""
}

variable "use_existing_storage_account" {
  type        = bool
  default     = false
  description = "(Optional) Flag used to set if the module should use an existing storage account. Defaults to false"
}

variable "use_existing_service_plan" {
  type        = bool
  default     = false
  description = "(Optional) Flag used to set if the module should use an existing service plan. Defaults to false"
}

variable "storage_access_key" {
  type        = string
  description = "(Optional) Storage account access key if using an already generated resource"
  default     = ""
  sensitive   = true
}

variable "service_plan_id" {
  type        = string
  description = "(Optional) Id of exiting service plan. Service plan generated if not set."
  default     = ""
}

variable "app_insights_connection_string" {
  type        = string
  description = "(Optional) Application insights connection string to connection logic app to applications insights. Connection string will be set in an app setting"
  default     = ""
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "(Optional) Application insights instrumentation key to connection logic app to applications insights. Instrumentation key will be set in an app setting"
  default     = ""
}

variable "runtime_version" {
  type        = string
  description = "(Optional) The runtime version associated with the logic app. Defaults to ~4"
  default     = "~4"
}

variable "https_only" {
  type        = bool
  description = "(Optional) Can the Logic App only be accessed via HTTPS? Defaults to false"
  default     = false
}

variable "public_network_access" {
  type        = bool
  description = "(Optional) Whether Public Network Access should be enabled or not. Defaults to false"
  default     = true
}

variable "client_certificate_mode" {
  type        = string
  description = "(Optional) The mode of the Logic App's client certificates requirement for incoming requests."
  default     = "Optional"
  validation {
    condition     = var.client_certificate_mode == "Optional" || var.client_certificate_mode == "Required"
    error_message = "Invalid client certificate mode. Possible values are - Optional or Required"
  }
}

variable "dotnet_framework_version" {
  type        = string
  description = "(Optional) The version of the .NET framework's CLR used in this Logic App. Defaults to v4.0"
  default     = "v4.0"
}

variable "runtime_scale_monitoring_enabled" {
  type        = bool
  description = "(Optional) Should Runtime Scale Monitoring be enabled?. Only applicable to apps on the Premium plan. Defaults to false"
  default     = false
}

variable "use_32_bit_worker_process" {
  type        = bool
  description = "(Optional) Should the Logic App run in 32 bit mode, rather than 64 bit mode? Defaults to true. When using app service plan in the Free or Shared Tiers use_32_bit_worker_process must be true"
  default     = true
}

variable "vnet_route_all_enabled" {
  type        = bool
  description = "(Optional) Should all outbound traffic have Virtual Network Security Groups and User Defined Routes applied."
  default     = true
}
variable "websockets_enabled" {
  type        = bool
  description = "(Optional) Should WebSockets be enabled? Defaults to false"
  default     = false
}

variable "pre_warmed_instance_count" {
  type        = number
  description = "(Optional) The number of pre-warmed instances for this Logic App Only affects apps on the Premium plan. Defaults to null"
  default     = null
}


variable "scm_type" {
  type        = string
  description = "Optional) The type of Source Control used by the Logic App in use by the Windows Function App. Defaults to None"
  default     = "None"
}

variable "linux_fx_version" {
  type        = string
  description = "(Optional) Linux App Framework and version for the App Service. Only applicable if os_type is set to Linux. Defaults to null"
  default     = null
}

variable "scm_min_tls_version" {
  type        = number
  description = "(Optional) Configures the minimum version of TLS required for SSL requests to the SCM site. Defaults to 1.2"
  default     = 1.2
}

variable "http2_enabled" {
  type        = bool
  description = "Optional) Specifies whether the HTTP2 protocol should be enabled. Defaults to false"
  default     = false
}

variable "scm_use_main_ip_restriction" {
  type        = bool
  description = "(Optional) Should the Logic App ip_restriction configuration be used for the SCM too. Defaults to false."
  default     = false
}

variable "health_check_path" {
  type        = string
  description = "(Optional) Path which will be checked for this Logic App health."
  default     = ""
}

variable "ftps_state" {
  type        = string
  description = " (Optional) State of FTP / FTPS service for this Logic App. Possible values include: AllAllowed, FtpsOnly and Disabled. Defaults to AllAllowed."
  default     = "AllAllowed"
  validation {
    condition     = contains(["AllAllowed", "Disabled", "FtpsOnly"], var.ftps_state)
    error_message = "Invalid ftps_state. Possible values are - AllAllowed, Disabled or FtpsOnly"
  }
}

variable "elastic_instance_minimum" {
  type        = number
  description = "(Optional) The number of minimum instances for this Logic App Only affects apps on the Premium plan."
  default     = null
}

variable "app_scale_limit" {
  type        = number
  description = "(Optional) The number of workers this Logic App can scale out to. Only applicable to apps on the Consumption and Premium plan."
  default     = null
}

variable "always_on" {
  type        = bool
  description = "(Optional) Should the Logic App be loaded at all times? Defaults to false"
  default     = false
}

# variable "storage_account_share_name" {
#   type = string
#   default = ""
# }
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

variable "maximum_elastic_worker_count" {
  type = number
  default = null
}