output "public_subnets_id" {
  value = [for i in aws_subnet.public-subnet : i.id]
}

output "private_subnets_id" {
  value = [for i in aws_subnet.private-subnet : i.id]
}

output "vpc_main" {
  value = aws_vpc.main
}