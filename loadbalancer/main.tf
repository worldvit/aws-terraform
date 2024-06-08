data "aws_acm_certificate" "cert" {
  domain   = "www.kdigital.shop"
  statuses = ["ISSUED"]
}

resource "aws_lb" "web" {
  name               = "lb-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_management_id]
  subnets            = [
    var.public-subnet-0,
    var.public-subnet-16]

  enable_deletion_protection = false

  tags = {
    Name = "lb-web"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "tg-web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc1
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "tg-web"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_launch_template" "web" {
  name          = "launch-template-web"
  # image_id      = var.ami_id
  image_id      = "ami-0cf59ea572d0fc60f" #wordpress
  instance_type = "t2.micro"
  key_name      = var.aws_key_pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.sg_management_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-instance"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [var.private-subnet-64]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  target_group_arns    = [aws_lb_target_group.web.arn]

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

# resource "aws_route53_record" "delete_existing_www_cname" {
#   zone_id = var.aws_route53_zone
#   name    = "www.kdigital.shop"
#   type    = "CNAME"
#   ttl     = 300
#   records = []

#   lifecycle {
#     prevent_destroy = false
#   }
# }

resource "aws_route53_record" "www_cname" {
  zone_id = var.aws_route53_zone
  name    = "www.kdigital.shop"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.web.dns_name]

  lifecycle {
    create_before_destroy = "true"
  }
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}