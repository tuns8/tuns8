variable "environment" {
  type        = string
  description = "(Required) custom variable. This is the environment name where the resource group will be created."

  # TO DO: VALIDATION COMMENTED PENDING ENVIRO NAMING CONVENTION STANDARDISATION
  # validation {
  #   condition     = var.environment == "dev" || var.environment == "test" || var.environment == "preprod" || var.environment == "prod"
  #   error_message = "Invalid environment name. Should be one of these - dev, test, preprod, prod"
  # }
}



variable "project" {
  type        = string
  description = "(Required) project name."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) custom variable. Resource Group Name"
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the logic app should exist. changing this forces a new Resource Group to be created"
  default     = "uksouth"
  validation {
    condition     = var.location == "uksouth" || var.location == "ukwest"
    error_message = "Invalid location name. Should be one of these - uksouth or ukwest"
  }
}