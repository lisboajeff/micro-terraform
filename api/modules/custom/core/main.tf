variable "root_name" {
  type        = string
  description = "Root name"
}

variable "domain_name" {
  type        = string
  description = "Custom domain name"
}

variable "type" {
  type    = string
  default = "REGIONAL"
}

variable "mtls" {
  type = object({
    enabled            = bool
    bucket             = optional(string)
    truststore_name    = optional(string)
    truststore_version = optional(string)
  })
}

data "aws_acm_certificate" "acm" {
  domain      = var.root_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "primary" {
  name = var.root_name
}

module "aws_api_gateway_root_name_mtls" {
  count                    = var.mtls.enabled ? 1 : 0
  source                   = "./mtls"
  mtls                     = var.mtls
  domain_name              = var.domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm.arn
  type                     = var.type
}

module "aws_api_gateway_root_name_comum" {
  count                    = var.mtls.enabled ? 0 : 1
  source                   = "./comum"
  domain_name              = var.domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm.arn
  type                     = var.type
}

module "aws_route53_record" {
  source               = "./record"
  domain_name          = var.domain_name
  route53_zone_id      = data.aws_route53_zone.primary.id
  regional_domain_name = var.mtls.enabled ? module.aws_api_gateway_root_name_mtls[0].regional_domain_name : module.aws_api_gateway_root_name_comum[0].regional_domain_name
  regional_zone_id     = var.mtls.enabled ? module.aws_api_gateway_root_name_mtls[0].regional_zone_id : module.aws_api_gateway_root_name_comum[0].regional_zone_id
}


