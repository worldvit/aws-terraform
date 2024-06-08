output "public-subnet-0" {
  value = module.network.public-subnet-0
}

output "database_public_ip" {
  value = module.instance.public_ip_1
}

output "web_public_ip" {
  value = module.instance.public_ip_2
}

output "aws_route53_zone" {
  value = module.route53.aws_route53_zone
}