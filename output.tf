output "public_ip_1" {
  value = aws_instance.web[*].public_ip
}

output "public_ip_2" {
  value = aws_instance.database[*].public_ip
}
output "sg_management_id" {
  value = aws_security_group.management.id
}