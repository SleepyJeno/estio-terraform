##############################
# security groups setup
##############################

resource "aws_security_group" "estio_ec2_sg" {
  name        = "estio_ec2_sg-tf"
  description = "Allow http and https traffic"
  vpc_id      = aws_vpc.estio_vpc.id

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

  tags = {
    Name = "estio_ec2_sg"
  }
}

resource "aws_security_group" "estio_db_sg_from_ec2_sg" {
  name        = "estio-db-sg-tf"
  description = "Allow 3306"
  vpc_id      = aws_vpc.estio_vpc.id

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

  tags = {
    Name = "estio_db_sg_from_ec2_sg"
  }
}



##############################
# Instance setup
##############################

resource "aws_db_instance" "estio_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "my-estio-db"
  db_name              = "estio_db"
  username             = "master"
  password             = "foobarbaz"
  port                 = 3306
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.estio_db_sg_from_ec2_sg.id]
  db_subnet_group_name   = module.subnets.db_subnet_group

}

resource "aws_instance" "ansible_controller" {
  ami           = "ami-0015a39e4b7c0966f"
  instance_type = "t2.micro"
  key_name      = "Linux-Day-3"
  subnet_id     = module.subnets.estio_public_1_subnet_id
  #subnet_id                   = "subnet-b0a335fc"
  vpc_security_group_ids      = [aws_security_group.estio_ec2_sg.id]
  associate_public_ip_address = true
  # user_data                   = file("scripts/ansible_install.sh") #uncomment for ansible setup
  user_data                   = file("_local_scripts/apache.sh") #uncomment for apache server 

  depends_on = [
    aws_db_instance.estio_db
  ]
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


##############################
# module calls
##############################

resource "aws_vpc" "estio_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "estio-vpc"
    }
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = aws_vpc.estio_vpc.id
}
