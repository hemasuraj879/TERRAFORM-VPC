# TERRAFORM VPC CREATION

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames


  tags = merge(
    var.common_tags,{
        Name = "${var.project_name}-vpc-${var.env}"
    }
  )
}

#PUBLIC SUBNET LEVEL CREATION
resource "aws_subnet" "public" {
  count = length(var.public_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = var.availability_zone[count.index]
  

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-public-${var.availability_zone[count.index]}"
    }
  )
}

#PRIVATE SUBNET LEVEL CREATION
resource "aws_subnet" "private" {
  count = length(var.private_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-private-${var.availability_zone[count.index]}"
    }
  )
}


# INTERNET GATEWAY CREATION

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.env}-ig"
    }
  )
}


# ROUTE TABLE CREATION

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,{
      Name = "${var.project_name}-${var.env}-public"
    }
  )
}

# ADDING ROUTE TO THE ROUTE TABLE
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.public.id
}

# ROUTE TABLE ASSOSICATION WITH SUBNETS

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# ELASTIC IP ADDRESS CREATION

resource "aws_eip" "lb" {

  domain   = "vpc"

  tags = merge(
    var.common_tags,{
      Name = "${var.project_name}-${var.env}-private"
    }
  )
}



# NAT GATEWAY CREATION THROUGH TERRAFORM

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,{
      Name = "${var.project_name}-${var.env}"
    }
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.public]
}


# PRIVATE ROUTE TABLE CREATION

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,{
      Name = "${var.project_name}-${var.env}"
    }
  )
}

# ADDING ROUTE TO THE ROUTE TABLE

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# ROUTE TABLE ASSOSICATION WITH SUBNETS

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
