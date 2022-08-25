module "bastion-host" {
  source = "./bastion"
}

module "eks" {
  source = "./eks-cluster"
}

module "s3-backend" {
  source         = "./backend-state"
  s3_bucket_name = "eks-tf-s3-state"
  dynamodb_name  = "eks-tf-state"
  region         = var.region
  aws_access_key = var.access_key
  aws_secret_key = var.aws.secret_key
}
