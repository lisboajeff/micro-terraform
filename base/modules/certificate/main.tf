variable "certificates" {
  description = "List of domains and their respective subdomains"
  type = list(object({
    name      = string
    wildcards = optional(list(string))
  }))
}

module "certificate" {
  for_each                  = { for domain in var.certificates : domain.name => domain }
  source                    = "./core"
  domain_name               = each.value.name
  subject_alternative_names = each.value.wildcards
}
