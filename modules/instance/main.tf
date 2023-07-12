data "aws_ami" "amazon-linux" {
most_recent = true
owners = ["amazon"]


  filter {
      name   = "name"
  #    values = ["amzn2-ami-hvm-*-gp2"]
      values = ["amzn2-ami-hvm-*"]
  }


  filter {
    name = "root-device-type"
    values = ["ebs"]
  }


  filter {
    name = "architecture"
    values = ["x86_64"]
  }


  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}
//==============================================
# Get latest Ubuntu Linux Bionic Beaver 18.04 AMI
data "aws_ami" "ubuntu-linux-1804" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Get latest Ubuntu Linux Focal Fossa 20.04 AMI
data "aws_ami" "ubuntu-linux-2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
//==============================================
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}


resource "aws_instance" "kubernetes" {
  ami = data.aws_ami.ubuntu-linux-2004.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true
  key_name = aws_key_pair.mykey.key_name

  for_each = toset(var.ec2_name)
 
  tags = {
    Name = each.key
  }
}
