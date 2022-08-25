resource "aws_route_table" "private-table" {
  for_each = local.subnets
  vpc_id   = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
  tags = {
    Name = "private-table-${each.key}"
  }
}


resource "aws_route_table" "public-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.public-subnet[each.key].id
  route_table_id = aws_route_table.public-table.id
}

resource "aws_route_table_association" "private" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.private-subnet[each.key].id
  route_table_id = aws_route_table.private-table[each.key].id
}

