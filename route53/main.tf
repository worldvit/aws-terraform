resource "aws_route53_zone" "kdigital_shop" {
  name = "kdigital-kt.shop"
}

resource "aws_route53_record" "server1-a" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "k8s.kdigital-kt.shop"
  type    = "A"
  ttl     = "300"
  // aws_instance.aws-webserver.public_ip <== output.tf
#   records = [aws_instance.web_server.public_ip]
  records = [var.public_ip_1]
}
resource "aws_route53_record" "server1-b" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "k8s-n1.kdigital-kt.shop"
  type    = "A"
  ttl     = "300"
  records = [var.public_ip_2]
}
resource "aws_route53_record" "server1-c" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
   name    = "k8s-n2.kdigital-kt.shop"
  type    = "A"
  ttl     = "300"
records = [var.public_ip_3]
}
resource "aws_route53_record" "server1-d" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
   name    = "k8s-n3.kdigital-kt.shop"
  type    = "A"
  ttl     = "300"
records = [var.public_ip_4]
}


// CNAME
resource "aws_route53_record" "www-cname-a" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "www.kdigital-kt.shop"
  type    = "CNAME"
  ttl     = "300"
  records = ["k8s.kdigital-kt.shop"]
}

resource "aws_route53_record" "www-cname-b" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "db.kdigital-kt.shop"
  type    = "CNAME"
  ttl     = "300"
  records = ["k8s-n1.kdigital-kt.shop"]
}

resource "aws_route53_record" "www-cname-c" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "ftp.kdigital-kt.shop"
  type    = "CNAME"
  ttl     = "300"
  records = ["k8s-n2.kdigital-kt.shop"]
}

resource "aws_route53_record" "www-cname-d" {
  zone_id = aws_route53_zone.kdigital_shop.zone_id
  name    = "nfs.kdigital-kt.shop"
  type    = "CNAME"
  ttl     = "300"
  records = ["k8s-n3.kdigital-kt.shop"]
}


output "aws_route53_zone" {
  value = aws_route53_zone.kdigital_shop
}