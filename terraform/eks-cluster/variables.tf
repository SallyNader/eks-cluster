variable "nfs" {}
variable "vpc_id" {}
# variable "image_id" {}
variable "key_name" {}
variable "pvt_max_size" {}
variable "pvt_min_size" {}
variable "cluster_name" {}
variable "nodes_sg_name" {}
variable "cluster_sg_name" {}
variable "node_group_name" {}
variable "pvt_desired_size" {}


variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type        = string
  default     = "AL2_x86_64"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 20."
  type        = number
  default     = 20
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "Set of instance types associated with the EKS Node Group."
}

variable "cluster_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "pblc_desired_size" {
  default = 1
  type    = number
}

variable "pblc_max_size" {
  default = 1
  type    = number
}

variable "pblc_min_size" {
  default = 1
  type    = number
}