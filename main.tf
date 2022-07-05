##############################
# security groups setup
##############################

resource "aws_security_group" "estio_ec2_sg" {
  name        = "estio_ec2_sg"
  description = "Allow http and https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "httpx from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "estio_db_sg_from_ec2_sg" {
  name        = "estio-db-sg"
  description = "Allow 3306"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.estio_ec2_sg.id]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############################
# subnets setup
##############################

resource "aws_subnet" "estio_public_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "estio_private_1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-2a"
}

resource "aws_subnet" "estio_private_2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "eu-west-2b"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "estio-database"
  subnet_ids = [aws_subnet.estio_private_1.id, aws_subnet.estio_private_2.id]
}

##############################
# Instance setup
##############################

resource "aws_instance" "ansible_controller" {
  ami           = "ami-0015a39e4b7c0966f"
  instance_type = "t2.micro"
  key_name      = "Linux-Day-3"
  subnet_id     = aws_subnet.estio_public_1.id
  #subnet_id                   = "subnet-b0a335fc"
  vpc_security_group_ids      = [aws_security_group.estio_ec2_sg.id]
  associate_public_ip_address = true
  # user_data                   = file("scripts/ansible_install.sh") #uncomment for ansible setup
  user_data                   = file("scripts/apache.sh") #uncomment for apache server 

  tags = {
    Name = "ansible_controller"
  }
}

# resource "aws_instance" "ansible_host" {
#   ami           = "ami-0015a39e4b7c0966f"
#   instance_type = "t2.micro"
#   key_name      = "Linux-Day-3"
#   subnet_id     = aws_subnet.estio_public_1.id
#   #subnet_id                   = "subnet-b0a335fc"
#   vpc_security_group_ids      = [aws_security_group.estio_ec2_sg.id]
#   associate_public_ip_address = true
#   # user_data                   = file("./flask.sh") #flask app setup
#   # user_data                   = file("scripts/host_setup.sh") #ansible setup


#   tags = {
#     Name = "ansible_host"
#   }
# }

##############################
# Output
##############################

output "ansible_controller_ip" {
  value = try(aws_instance.ansible_controller.public_ip, null)
}

# output "ansible_host_ip" {
#   value = try(aws_instance.ansible_host.public_ip, null)
# }