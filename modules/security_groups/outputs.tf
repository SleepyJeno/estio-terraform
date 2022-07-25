output "estio_db_sg_from_ec2_sg_id" {
    value = aws_security_group.estio_db_sg_from_ec2_sg.id
}

output "estio_ec2_sg_id" {
    value = aws_security_group.estio_ec2_sg.id
}