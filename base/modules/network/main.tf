variable "data" {
  type = any
}

module "setup" {
  source  = "./data"
  domains = var.data.domains
}

module "network" {
  for_each    = { for domain in module.setup.output : domain.name => domain }
  source      = "./core"
  domain_name = each.value.name
}
