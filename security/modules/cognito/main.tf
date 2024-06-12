variable "data" {
  type = any
}

module "setup" {
  source    = "./data"
  userpools = var.data.userpools
}
