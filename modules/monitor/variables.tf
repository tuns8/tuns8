variable "environment" {
  type        = string
  description = "(Required) The environment name where the Application Insights will be created."

  # TO DO: VALIDATION COMMENTED PENDING ENVIRO NAMING CONVENTION STANDARDISATION
  # validation {
  #   condition     = var.environment == "dev" || var.environment == "npa" || var.environment == "stg" || var.environment == "prod"
  #   error_message = "Invalid environment name. Should be one of these - dev, npa, stg, prod."
  # }
}

variable "main_project" {
  type        = string
  description = "(Required) Main project name (lowercase letters and numbers only)."

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.main_project))
    error_message = "main_project must be lowercase letters and numbers only."
  }
}

variable "sub_project" {
  type        = string
  description = "(Required) Sub-project name (lowercase letters and numbers only)."

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.sub_project))
    error_message = "sub_project must be lowercase letters and numbers only."
  }
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the resources will be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the resources should exist."
}

variable "application_type" {
  type        = string
  description = "(Required) The type of Application Insights component. Possible values are 'web', 'other'."

  validation {
    condition     = var.application_type == "web" || var.application_type == "other"
    error_message = "Invalid application_type. Should be 'web' or 'other'."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resources."
  default     = {}
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "(Optional) The SKU of the Log Analytics Workspace. Default is 'PerGB2018'."
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "(Optional) The retention period for the Log Analytics Workspace in days. Default is 30."
  default     = 30
}
