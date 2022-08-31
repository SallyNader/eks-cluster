variable "s3_key" {}
variable "hash_key" {}
variable "kms_alias" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "s3_bucket_name" {
  default = "s3-backend"
}

variable "dynamodb_name" {
  default = "dynamodb-table"
}
