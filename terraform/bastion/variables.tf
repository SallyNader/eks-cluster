variable "key" {}
variable "vpc_id" {}
variable "image_id" {}
variable "min_size" {}
variable "max_size" {}
variable "template_name" {}
variable "instance_type" {}
variable "desired_capacity" {}

variable "subnets_ids" {
  type = list(string)
}