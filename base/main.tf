module "data_certificate" {
  source      = "./modules/config"
  module_name = "certificate"
  config      = var.config
}

module "certificate" {
  source       = "./modules/certificate"
  count        = module.data_certificate.data_exists ? 1 : 0
  certificates = module.data_certificate.output.certificates
}

########################################################

module "data_network" {
  source      = "./modules/config"
  module_name = "network"
  config      = var.config
}

module "network" {
  source = "./modules/network"
  count  = module.data_network.data_exists ? 1 : 0
  data   = module.data_network.output
}
