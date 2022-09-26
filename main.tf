terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  project = "basic-architect"
}

module "networking" {
  source = "./modules/networking"
  project          = local.project
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

module "database" {
  source = "./modules/database"
  project = local.project
  vpc     = module.networking.vpc
  sg      = module.networking.sg
}

module "autoscaling" {
  source = "./modules/autoscaling"
  project   = local.project
  vpc       = module.networking.vpc
  sg        = module.networking.sg
  db_config = module.database.config
}