module "vpc" {
  source         = "./vpc"
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
