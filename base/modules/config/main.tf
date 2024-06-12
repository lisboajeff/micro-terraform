variable "config" {
  type = object({
    country     = string
    environment = string
    file_path   = string
  })
}

variable "module_name" {
  type = string
}

locals {
  country_path          = "${var.config.file_path}/environments/${var.config.country}/${var.module_name}.yml"
  environment_path      = "${var.config.file_path}/environments/${var.config.country}/${var.config.environment}/${var.module_name}.yml"
  country_exists        = fileexists(local.country_path)
  environment_exists    = fileexists(local.environment_path)
  yaml_data_country     = local.country_exists ? yamldecode(file(local.country_path)) : {}
  yaml_data_environment = local.environment_exists ? yamldecode(file(local.environment_path)) : {}
  yaml_data             = merge(local.yaml_data_country, local.yaml_data_environment)
}

output "output" {
  value = local.yaml_data
}

output "data_exists" {
  value = local.country_exists || local.environment_exists
}
