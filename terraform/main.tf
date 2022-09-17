module "vpc" {
  source         = "./vpc"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

module "bastion-host" {
  source             = "./bastion"
  desired_capacity   = 3
  max_size           = 4
  min_size           = 3
  key                = aws_key_pair.ec2-key.key_name
  template_name      = "linux"
  vpc_id             = module.vpc.vpc_main.id
  instance_type      = "t2.micro"
  image_id           = "ami-0022f774911c1d690"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

terraform {
  backend "s3" {
    key            = "terraform/key"
    bucket         = "eks-tf-s3-state"
    region         = "us-east-1"
    dynamodb_table = "eks-tf-state"
  }
}
