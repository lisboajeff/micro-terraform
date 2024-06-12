module "data_cognito" {
  source      = "../base/modules/config"
  module_name = "cognito"
  config      = var.config
}

module "cognito" {
  source = "./modules/cognito"
  count  = module.data_cognito.data_exists ? 1 : 0
  data   = module.data_cognito.output
}
