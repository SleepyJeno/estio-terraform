output "db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.id
}

output "estio_public_1_subnet_id" {
    value = aws_subnet.estio_public_1.id
}

output "estio_private_1_subnet_id" {
    value = aws_subnet.estio_private_1.id
}

output "estio_private_2_subnet_id" {
    value = aws_subnet.estio_private_1.id
}
