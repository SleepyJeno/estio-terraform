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
  ec2_user_data         = file("_local_scripts/apache.sh")
}