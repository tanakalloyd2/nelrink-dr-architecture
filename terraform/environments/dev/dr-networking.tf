resource "aws_vpc" "dr_vpc" {
  provider             = aws.dr
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Nelrink-DR-VPC"
  }
}

resource "aws_subnet" "dr_public_subnet" {
  provider                = aws.dr
  vpc_id                  = aws_vpc.dr_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "DR-Public-Subnet"
  }
}

resource "aws_subnet" "dr_app_subnet" {
  provider   = aws.dr
  vpc_id     = aws_vpc.dr_vpc.id
  cidr_block = "10.1.11.0/24"

  tags = {
    Name = "DR-App-Subnet"
  }
}

resource "aws_subnet" "dr_db_subnet" {
  provider   = aws.dr
  vpc_id     = aws_vpc.dr_vpc.id
  cidr_block = "10.1.21.0/24"

  tags = {
    Name = "DR-DB-Subnet"
  }
}

resource "aws_internet_gateway" "dr_igw" {
  provider = aws.dr
  vpc_id   = aws_vpc.dr_vpc.id

  tags = {
    Name = "DR-IGW"
  }
}

resource "aws_route_table" "dr_public_rt" {
  provider = aws.dr
  vpc_id   = aws_vpc.dr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dr_igw.id
  }

  tags = {
    Name = "DR-Public-RT"
  }
}

resource "aws_route_table_association" "dr_public_assoc" {
  provider       = aws.dr
  subnet_id      = aws_subnet.dr_public_subnet.id
  route_table_id = aws_route_table.dr_public_rt.id
}