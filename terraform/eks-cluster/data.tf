# Gets sebnets of default vpc.
data "aws_vpc" "default-vpc-data" {
  default = true
}


data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc-data.id]
  }
}

data "aws_subnet" "default-subnet" {
  for_each = toset(data.aws_subnets.default-subnets.ids)
  id       = each.value
}