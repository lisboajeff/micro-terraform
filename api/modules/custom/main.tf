variable "data" {
  type = any
}

module "setup" {
  source  = "./data"
  domains = var.data.domains
}

locals {
  map = {
    for item in flatten([
      for domain in module.setup.output : [
        for custom in domain.custom : {
          key = "${custom.name}",
          value = {
            root_name   = domain.name,
            domain_name = custom.name,
            mtls        = custom.mtls != null ? merge(custom.mtls, { enabled = true }) : { enabled = false }
          }
        }
      ]
    ]) : item.key => item.value
  }
}

module "custom_domain" {
  for_each    = local.map
  source      = "./core"
  root_name   = each.value.root_name
  domain_name = each.value.domain_name
  mtls        = each.value.mtls
}
