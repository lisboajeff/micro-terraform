provider "aws" {
  region  = "sa-east-1"
  profile = "desenvolvimento"
}

terraform {
  backend "s3" {
    bucket         = "terraform.state.knin.cloud"
    key            = "api/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "core-terraform-lock-table"
    encrypt        = true
    profile        = "desenvolvimento"
  }
}
