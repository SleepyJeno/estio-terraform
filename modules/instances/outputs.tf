
##############################
# Output
##############################

output "ansible_controller_ip" {
  value = try(aws_instance.ansible_controller.public_ip, null)
}

# output "ansible_host_ip" {
#   value = try(aws_instance.ansible_host.public_ip, null)
# }

output "rds_endpoint" {
  value = aws_db_instance.estio_db.endpoint
}
output "db_name" {
  value = aws_db_instance.estio_db.db_name
}
output "rds_username" {
  value = aws_db_instance.estio_db.username
}
output "rds_password" {
  value = aws_db_instance.estio_db.password
}
output "rds_port" {
  value = aws_db_instance.estio_db.port
}