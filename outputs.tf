output "ec2_controller_public_ip" {
    value = module.instances.ansible_controller_ip
}