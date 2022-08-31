variable "nfs" {}
variable "max_size" {}
variable "key" {}
variable "min_size" {}
variable "key_name" {}
variable "vpc_id" {}
variable "image_id" {}
variable "bastion_id" {}
variable "cluster_name" {}
variable "template_name" {}
variable "instance_type" {}
variable "user_data_file" {}
variable "node_group_name" {}
variable "desired_capacity" {}
variable "subnets_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
