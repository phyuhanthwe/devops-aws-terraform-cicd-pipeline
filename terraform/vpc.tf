resource "aws_vpc" "custom-demo-vpc" {
  cidr_block           = "173.31.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-custom-vpc"
  }
}

resource "aws_subnet" "custom-demo-subnet" {
  vpc_id            = aws_vpc.custom-demo-vpc.id
  cidr_block        = "173.31.0.0/20"
  availability_zone = var.az
  tags = {
    Name = "${var.prefix}-custom-sbunet"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.custom-demo-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.custom-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }


  tags = {
    Name = "${var.prefix}-rt"
  }
}

resource "aws_route_table_association" "demo-rta" {
  subnet_id      = aws_subnet.custom-demo-subnet.id
  route_table_id = aws_route_table.demo_rt.id
}