module "vpc" {
  source         = "./vpc"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

module "nfs" {
  source      = "./nfs"
  vpc_id      = module.vpc.vpc_main.id
  cidr_blocks = module.vpc.vpc_main.cidr_block
  subnet_ids  = concat(module.vpc.public_subnets_id, module.vpc.private_subnets_id)
}

module "bastion-host" {
  source           = "./bastion"
  desired_capacity = 3
  max_size         = 4
  min_size         = 3
  key              = "ec2-ssh"
  template_name    = "linux"
  subnets_ids      = module.vpc.public_subnets_id
  vpc_id           = module.vpc.vpc_main.id
  instance_type    = "t2.micro"
  image_id         = "ami-0022f774911c1d690"
}

module "eks-cluster" {
  source              = "./eks-cluster"
  nfs                 = module.nfs.efs
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  key_name            = "ec2-ssh"
  vpc_id              = module.vpc.vpc_main.id
  cluster_subnets_ids = module.vpc.public_subnets_id
  instance_type       = "t3.medium"
  cluster_name        = "eks-cluster"
  node_group_name     = "worker-nodes"
  template_name       = "linux-eks-nodes"
  image_id            = "ami-0022f774911c1d690"
  bastion_id          = module.bastion-host.sg-bastion
  user_data_file      = "../bash/script.sh"
  subnets_ids          = module.vpc.private_subnets_id
}

terraform {
  backend "s3" {
    key            = "terraform/key"
    bucket         = "eks-tf-s3-state"
    region         = "us-east-1"
    dynamodb_table = "eks-tf-state"
  }
}
