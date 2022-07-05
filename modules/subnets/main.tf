##############################
# subnets setup
##############################
resource "aws_subnet" "estio_public_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "estio-tf-public-1"
  }
}
resource "aws_subnet" "estio_private_1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "estio-tf-private-1"
  }
}

resource "aws_subnet" "estio_private_2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "estio-tf-private-2"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "estio-database"
  subnet_ids = [aws_subnet.estio_private_1.id, aws_subnet.estio_private_2.id]
}

##############################
# Routing setup
##############################
resource "aws_route_table" "estio_private_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "private-estio-rt"
  }
}

resource "aws_route_table" "estio_public_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "public-estio-rt"
  }
}

resource "aws_route_table_association" "estio_private_1" {
  subnet_id      = aws_subnet.estio_private_1.id
  route_table_id = aws_route_table.estio_private_rt.id
}

resource "aws_route_table_association" "estio_private_2" {
  subnet_id      = aws_subnet.estio_private_2.id
  route_table_id = aws_route_table.estio_private_rt.id
}

resource "aws_route_table_association" "estio_public_1" {
  subnet_id      = aws_subnet.estio_public_1.id
  route_table_id = aws_route_table.estio_public_rt.id
}