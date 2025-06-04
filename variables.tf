############################
#  Provider Configuration  #
############################

variable "worker_id" {
    description = "Client Id"
    type = string
}
variable "worker_secret" {
    description = "Client Secret"
    type = string
    sensitive = true
}
variable "pingone_environment_id" {
    description = "Environment Id"
    type = string
}

variable "region_code" {
    description = "Region"
    type = string
    default = "NA"
}

variable "license_id" {
  type        = string
  description = "Name of the P1 license you want to assign to the Environment"
}

variable "organization_id" {
    type      = string
    description = "Org ID"
}


#############
#  PingOne  #
#############

variable "environment_type" {
  type        = string
  description = "Type of the PingOne Environment. Allowed values: \"SANDBOX\", \"PRODUCTION\""

  validation {
    condition     = contains(["SANDBOX", "PRODUCTION"], var.environment_type)
    error_message = "Must be either \"SANDBOX\" or \"PRODUCTION\"."
  }
}

variable "environment_name_master" {
  type        = string
  description = "Name of the PingOne Environment"
}
