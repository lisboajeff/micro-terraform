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

variable "mtls" {
  type = object({
    bucket             = string
    truststore_name    = string
    truststore_version = string
  })
}

data "aws_s3_object" "truststore" {
  bucket = var.mtls.bucket
  key    = var.mtls.truststore_name
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.regional_certificate_arn
  endpoint_configuration {
    types = [var.type]
  }
  security_policy = "TLS_1_2"
  mutual_tls_authentication {
    truststore_uri     = "s3://${data.aws_s3_object.truststore.id}"
    truststore_version = var.mtls.truststore_version
  }
}

output "regional_domain_name" {
  value = aws_api_gateway_domain_name.api_domain.regional_domain_name
}

output "regional_zone_id" {
  value = aws_api_gateway_domain_name.api_domain.regional_zone_id
}
