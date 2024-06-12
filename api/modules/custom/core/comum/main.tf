variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "regional_certificate_arn" {
  type        = string
  description = "CERTIFICATE ARN"
}

variable "type" {
  type    = string
  default = "REGIONAL"
}


resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.regional_certificate_arn
  endpoint_configuration {
    types = [var.type]
  }
}

output "regional_domain_name" {
  value = aws_api_gateway_domain_name.api_domain.regional_domain_name
}

output "regional_zone_id" {
  value = aws_api_gateway_domain_name.api_domain.regional_zone_id
}
