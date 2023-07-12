resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "ssh network traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = "22 from workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allowed SSH"
  }
}


resource "aws_security_group" "RDP" {
  name        = "RDP"
  description = "RDP network traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = "3389 from workstation"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow RDP"
  }
}
