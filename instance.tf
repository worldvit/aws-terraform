/*
resource "aws_instance" "web-server" {
  # last parameter is the default value
  ami           = lookup(var.AMIS, var.AWS_REGION, "") 
  instance_type = "t2.micro"
}
*/