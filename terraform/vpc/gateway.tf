resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw-main"
  }
}

resource "aws_eip" "nat" {
  for_each = local.subnets
}

resource "aws_nat_gateway" "nat" {
  depends_on    = [aws_internet_gateway.gw, aws_eip.nat]
  for_each      = local.subnets
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public-subnet[each.key].id

  tags = {
    Name = "nat-${each.key}"
  }
}


