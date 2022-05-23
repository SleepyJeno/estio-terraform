resource "aws_security_group" "estio-ec2-sg" {
  name        = "estio-ec2-sg"
  description = "Allow http and https traffic"
  vpc_id      = "vpc-3da39155"

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
resource "aws_instance" "ansible_controller" {
  ami                         = "ami-0015a39e4b7c0966f"
  instance_type               = "t2.micro"
  key_name                    = "Linux-Day-3"
  subnet_id                   = "subnet-b0a335fc"
  vpc_security_group_ids      = [aws_security_group.estio-ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = file("./ansible_install.sh")
  #user_data                   = file("./apache.sh")

  tags = {
    Name = "estio"
  }
}

resource "aws_instance" "ansible_host" {
  ami                         = "ami-0015a39e4b7c0966f"
  instance_type               = "t2.micro"
  key_name                    = "Linux-Day-3"
  subnet_id                   = "subnet-b0a335fc"
  vpc_security_group_ids      = [aws_security_group.estio-ec2-sg.id]
  associate_public_ip_address = true
  #user_data                   = file("./flask.sh")

  tags = {
    Name = "estio"
  }
}

output "my_ips" {
  value = [aws_instance.ansible_controller.public_ip, aws_instance.ansible_host.public_ip]
}
