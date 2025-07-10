resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "vpc-${var.env}"
  }  
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)  #2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${count.index + 1}-${var.env}"
  }  
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${var.env}"
  }  
}


