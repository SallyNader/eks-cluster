output "public-subnet-output" {
  for_each = local.subnets
  value    = each_value["public_cidr"]
}

output "private-subnet-output" {
  for_each = local.subnets
  value    = each_value["private_cidr"]
}

output "vpc_main" {
  value = aws_vpc.main
}