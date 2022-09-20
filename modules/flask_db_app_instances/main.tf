
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

resource "aws_instance" "webserver" {
  ami                         = var.ami_app
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key
  associate_public_ip_address = true
  private_ip                  = "10.0.11.10"
  subnet_id                   = var.ec2_controller_subnet
  security_groups             = var.ec2_security_groups
  user_data                   = <<-EOL
  #!/bin/bash 
  sudo apt update
  sudo touch /home/ubuntu/username /home/ubuntu/password /home/ubuntu/endpoint /home/ubuntu/name
  sudo chown ubuntu /home/ubuntu/username /home/ubuntu/username /home/ubuntu/password /home/ubuntu/endpoint /home/ubuntu/name
  sudo chgrp ubuntu /home/ubuntu/username /home/ubuntu/username /home/ubuntu/password /home/ubuntu/endpoint /home/ubuntu/name
  sudo echo "USERNAME=${aws_db_instance.estio_db.username}" >> /etc/environment
  sudo echo "PASSWORD=${aws_db_instance.estio_db.password}" >> /etc/environment
  sudo echo "ENDPOINT=${aws_db_instance.estio_db.endpoint}" >> /etc/environment
  sudo echo "NAME=${aws_db_instance.estio_db.db_name}" >> /etc/environment
  EOL

}

resource "null_resource" "connect_web" {
  provisioner "remote-exec" {
    inline = [
      "sudo echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
    ]
    connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/Linux-Day-3.pem")
    }

  }
  depends_on = [aws_instance.webserver]
}

resource "null_resource" "file_transfer" {
  provisioner "file" {
    source      = "${path.module}/ansible-project"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/Linux-Day-3.pem")
      host        = aws_instance.webserver.public_ip
    }
  }

  depends_on = [
    aws_instance.webserver, null_resource.connect_web
  ]

}

resource "null_resource" "connect_web2" {
  provisioner "remote-exec" {
    inline = [
      "sudo su -l ubuntu -c 'sudo git clone https://github.com/nathanforester/FlaskMovieDB2.git'",
      "sudo su -l ubuntu -c 'sudo chown -R /home/ubuntu/FlaskMovieDB2'",
      "sudo su -l ubuntu -c 'sudo chown ubuntu /home/ubuntu/FlaskMovieDB2/startup.sh /home/ubuntu/FlaskMovieDB2/create.py /home/ubuntu/FlaskMovieDB2/app.py'",
      "sudo su -l ubuntu -c 'sudo apt install mysql-server -y'",
      "sudo su -l ubuntu -c 'sudo apt install software-properties-common'",
      "sudo su -l ubuntu -c 'sudo add-apt-repository --yes --update ppa:ansible/ansible'",
      "sudo su -l ubuntu -c 'sudo apt install ansible -y'",
      "sudo su -l ubuntu -c 'ansible-playbook /home/ubuntu/ansible-project/playbook.yaml'",
      "sudo su -l ubuntu -c 'sudo chown ubuntu /var/run/docker.sock'",
      "sudo su -l ubuntu -c '. /home/ubuntu/FlaskMovieDB2/startup.sh'",
    ]

    connection {
      host        = aws_instance.webserver.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/Linux-Day-3.pem")
    }

  }
  depends_on = [aws_instance.webserver, null_resource.connect_web, null_resource.file_transfer]
}
