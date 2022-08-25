variable "s3_bucket_name" {
  default = "s3-backend"
}

variable "dynamodb_name" {
  default = "dynamodb-table"
}

variable "region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}