module "vpc" {
  source         = "./vpc"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

module "nfs" {
  source         = "./nfs"
  vpc_id         = module.vpc.vpc_main.id
  cidr_blocks    = module.vpc.vpc_main.cidr_block
  subnet_ids     = concat(module.vpc.public_subnets_id, module.vpc.private_subnets_id)
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    key            = "terraform/key"
    bucket         = "eks-tf-s3-state"
    region         = "us-east-1"
    dynamodb_table = "eks-tf-state"
  }
}
