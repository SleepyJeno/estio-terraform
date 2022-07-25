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

  vpc_security_group_ids = var.db_security_groups
  db_subnet_group_name   = var.db_subnet_group

}

resource "aws_instance" "ansible_controller" {
  ami           = "ami-0015a39e4b7c0966f"
  instance_type = "t2.micro"
  key_name      = "Linux-Day-3"
  subnet_id     = var.ec2_controller_subnet
  vpc_security_group_ids      = var.ec2_security_groups
  associate_public_ip_address = true
  user_data                   = var.ec2_user_data

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