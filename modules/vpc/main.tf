data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  ipv4_ipam_pool_id   = var.ipam_pool_id
  ipv4_netmask_length = var.vpc_netmask
}

resource "aws_subnet" "priv-subnet" {
  for_each          = toset(var.opted_availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[index(var.opted_availability_zones, each.key)]
  availability_zone = "${var.aws_region}${each.key}"

  tags = {
    "Name" = "priv-subnet-${each.key}"
  }
}

resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "priv-rt"
  }
}

resource "aws_route_table_association" "priv" {
  for_each       = toset(var.opted_availability_zones)
  subnet_id      = aws_subnet.priv-subnet[each.key].id
  route_table_id = aws_route_table.priv-rt.id
}

resource "aws_route" "route_to_ngw" {
  route_table_id         = aws_route_table.priv-rt.id
  nat_gateway_id         = aws_nat_gateway.ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "pub-subnet" {
  for_each          = toset(var.opted_availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[index(var.opted_availability_zones, each.key)]
  availability_zone = "${var.aws_region}${each.key}"

  tags = {
    "Name" = "pub-subnet-${each.key}"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "pub-rt"
  }
}

resource "aws_route_table_association" "pub" {
  for_each       = toset(var.opted_availability_zones)
  subnet_id      = aws_subnet.pub-subnet[each.key].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_eip" "ngw" {}

resource "aws_nat_gateway" "ngw" { ##Single AZ only for cost ops for now
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.pub-subnet["a"].id

  tags = {
    Name = "ngw-a"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}


resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.pub-rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

}
