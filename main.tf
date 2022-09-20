##############################
# module calls
##############################

resource "aws_vpc" "estio_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "estio-vpc"
  }
}

resource "aws_internet_gateway" "estio_igw" {
  vpc_id = aws_vpc.estio_vpc.id

  tags = {
    Name = "estio-igw"
  }
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = aws_vpc.estio_vpc.id
  igw_id = aws_internet_gateway.estio_igw.id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.estio_vpc.id
}

module "instances" {
  source                = "./modules/instances"
  vpc_id                = aws_vpc.estio_vpc.id
  ec2_controller_subnet = module.subnets.estio_public_1_subnet_id
  db_subnet_group       = module.subnets.db_subnet_group
  db_security_groups    = [module.security_groups.estio_db_sg_from_ec2_sg_id]
  ec2_security_groups   = [module.security_groups.estio_ec2_sg_id]
  ec2_user_data         = <<-EOL
#!/bin/bash 
sudo apt update
sudo echo "USERNAME=${module.instances.rds_username}" >> /home/ubuntu/.bashrc
sudo echo "PASSWORD=${module.instances.rds_password}" >> /home/ubuntu/.bashrc
sudo echo "DBNAME=${module.instances.db_name}" >> /home/ubuntu/.bashrc
sudo echo ENDPOINT=${module.instances.rds_endpoint} | cut -d: -f1 >> /home/ubuntu/.bashrc
source ~/.bashrc
sudo git clone https://github.com/nathanforester/FlaskMovieDB2.git
sudo apt install mysql-server -y
sudo apt install docker.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
. /home/ubuntu/FlaskMovieDB2/startup.sh
touch /home/ubuntu/mysql_script
echo "CREATE TABLE people(id SERIAL, FirstName varchar(55),LastName varchar(55));" >> /home/ubuntu/mysql_script
echo "INSERT INTO people(FirstName, LastName) VALUES ('Jack', 'Babber');" >> /home/ubuntu/mysql_script
echo "INSERT INTO people(FirstName, LastName) VALUES ('John', 'Ginger');" >> /home/ubuntu/mysql_script
echo "INSERT INTO people(FirstName, LastName) VALUES ('Tester', 'Test');" >> /home/ubuntu/mysql_script
mysql -h $ENDPOINT -P 3306 -u $USERNAME -p$PASSWORD $DBNAME < /home/ubuntu/mysql_script
EOL
}

module "flask_db_app_instances" {
  source                = "./modules/flask_db_app_instances"
  vpc_id                = aws_vpc.estio_vpc.id
  ec2_controller_subnet = module.subnets.estio_public_1_subnet_id
  db_subnet_group       = module.subnets.db_subnet_group
  db_security_groups    = [module.security_groups.estio_db_sg_from_ec2_sg_id]
  ec2_security_groups   = [module.security_groups.estio_ec2_sg_id]
}