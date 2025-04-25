# modules/vpc/main.tf
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  
  enable_dns_hostnames = true
  tags = {
    Name = "Main_VPC"
	Environment= "dev"
	Project = "dev-${var.project_name}" 
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Main_IGW"
	Environment = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
	Environment = "dev"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "db_subnet" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "db-subnet-${count.index}"
  Environment = "dev"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_associate" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP for NAT Gateway 
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Environment = "dev"
  }
}

# NAT Gateway in first public subnet (you can choose index 0 or 1)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    Environment = "dev"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route table for private subnets to use the NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Environment = "dev"
  }
}

# Associate private route table with both private subnets
resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private_subnet)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}




