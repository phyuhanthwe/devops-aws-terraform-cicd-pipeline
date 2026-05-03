terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.43.0"
    }
  }
  backend "s3" {
    bucket       = var.bucket-name
    key          = "dev/terraform.tfstate"
    region       = var.region
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  # profile = "master-console-admin"
  region = var.region
}