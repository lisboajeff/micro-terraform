variable "domains" {
  description = "List of domains"
  type = list(object({
    name = string
    custom = list(object({
      name = string
      mtls = optional(object({
        bucket             = string
        truststore_name    = string
        truststore_version = string
      }))
    }))
  }))
}

output "output" {
  value = var.domains
}
