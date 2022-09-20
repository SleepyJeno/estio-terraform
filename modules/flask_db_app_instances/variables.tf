variable "ami_app" {
  type    = string
  default = "ami-0015a39e4b7c0966f"
}
variable "ssh_key" {
  type    = string
  default = "Linux-Day-3"
}
variable "vpc_id" {}
variable "ec2_controller_subnet" {}
variable "db_subnet_group" {}
variable "ec2_security_groups" {}
variable "db_security_groups" {}
