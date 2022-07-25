
##############################
# Output
##############################

output "ansible_controller_ip" {
  value = try(aws_instance.ansible_controller.public_ip, null)
}

# output "ansible_host_ip" {
#   value = try(aws_instance.ansible_host.public_ip, null)
# }