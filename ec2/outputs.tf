output "security_group_id" {
  value = aws_security_group.access_security_group.id
}

output "webserver" {
  value = aws_instance.webserver.id
}

output "elasticip" {
  value = aws_eip.elasticip.public_ip
}