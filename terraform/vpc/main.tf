terraform {
  backend "s3" {
    key            = "terraform/vpc"
    bucket         = "eks-tf-s3-state"
    region         = "us-east-1"
    dynamodb_table = "eks-tf-state"
  }
}
