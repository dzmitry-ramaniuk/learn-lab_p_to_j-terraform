resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "public-lab-subnet" {
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-lab-subnet"
  }
}

resource "aws_subnet" "private-lab-subnet" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-lab-subnet"
  }
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "lab-igw"
  }
}

resource "aws_route_table" "public-lab-route-table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-igw.id
  }

  tags = {
    Name = "public-lab-route-table"
  }
}

resource "aws_route_table_association" "public-lab-route-table-association" {
  subnet_id      = aws_subnet.public-lab-subnet.id
  route_table_id = aws_route_table.public-lab-route-table.id
}