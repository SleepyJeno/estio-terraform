output "public_ip_ad" {
    value = aws_instance.webserver.public_ip
}