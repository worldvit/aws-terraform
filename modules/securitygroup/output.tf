output "ssh_sg_id" {
  description = "ssh sg id"
  value       = aws_security_group.ssh.id
}


output "rdp_sg_id" {
  description = "RDP sg id"
  value       = aws_security_group.RDP.id
}
