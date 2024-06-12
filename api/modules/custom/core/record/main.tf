variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "regional_domain_name" {
  type        = string
  description = "Regional Domain name"
}

variable "regional_zone_id" {
  type        = string
  description = "Regional Zona ID"
}

variable "route53_zone_id" {
  type = string
}

resource "aws_route53_record" "api_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.regional_domain_name
    zone_id                = var.regional_zone_id
    evaluate_target_health = true
  }
}
