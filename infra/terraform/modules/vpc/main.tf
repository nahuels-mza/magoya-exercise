# Define two availability zones (AZs)
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
# Create a VPC
resource "aws_vpc" "magoya_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "magoya vpc"
  }
}


# Create a public subnet
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.magoya_vpc.id
  cidr_block              = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/cluster/magoya-test" = "owned"
    "kubernetes.io/role/elb"            = 1
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.magoya_vpc.id
  cidr_block        = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "kubernetes.io/cluster/magoya-test" = "owned"
    "kubernetes.io/role/elb"            = 1
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.magoya_vpc.id

  tags = {
    Name = "magoya igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.magoya_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = 2

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}

resource "aws_eip" "nat" {
  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
