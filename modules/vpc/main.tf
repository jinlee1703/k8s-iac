resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-vpc"
    }
  )
}

resource "aws_subnet" "net" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-net-public/az${count.index + 1}"
    }
  )
}

resource "aws_subnet" "app" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones) + 1)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-app-private/az${count.index + 1}"
    }
  )
}

resource "aws_subnet" "data" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones) * 2 + 1)
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-data-private/az${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  vpc   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-nat-eip/az${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.net[count.index].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-nat-gw/az${count.index + 1}"
    }
  )
}

resource "aws_route_table" "net" {
  vpc_id = aws_vpc.main.id
  count  = length(var.availability_zones)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-rtb-net"
    }
  )
}

resource "aws_route_table_association" "net" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.net[count.index].id
  route_table_id = aws_route_table.net[count.index].id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  count  = length(var.availability_zones)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-rtb-app"
    }
  )
}

resource "aws_route_table_association" "app" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.main.id
  count  = length(var.availability_zones)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-rtb-data"
    }
  )
}

resource "aws_route_table_association" "data" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data[count.index].id
}
