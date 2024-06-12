module "data_custom_domain" {
  source      = "../base/modules/config"
  module_name = "custom"
  config      = var.config
}

module "custom_domain" {
  source = "./modules/custom"
  count  = module.data_custom_domain.data_exists ? 1 : 0
  data   = module.data_custom_domain.output
}
