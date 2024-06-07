# get an ami for amazon
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# get an ami for ubuntu
data "aws_ami" "ubuntu-linux" {
  most_recent = true
  owners = [ "099720109477" ]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Create an instance using amazon ami
resource "aws_instance" "web" {
  # ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [ var.sg_management_id ]
  subnet_id = var.subnet-0

  root_block_device {
    volume_size = "20"
    volume_type = "gp2"

    tags = {
      Name = "root-device"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl enable --now nginx
    echo "WEB Pages" | sudo tee /usr/share/nginx/html/index.html
    sudo systemctl restart nginx
  EOF

  tags = {
    Name = "web-${count.index}"
  }
}

# Create an instance using ubuntu ami
resource "aws_instance" "database" {
#   ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.ubuntu-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids =  [ var.sg_management_id ]
  subnet_id = var.subnet-16
  associate_public_ip_address = true

  root_block_device {
    volume_size = "20"
    volume_type = "gp2"

    tags = {
      Name = "root-device"
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo systemctl enable --now nginx
    echo "WEB Pages" | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "database-${count.index}"
  }
}
/*
resource "aws_instance" "web-2" {
  # ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [ aws_security_group.management.id ]
}
*/

# Create public key
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# output "public_ip_1" {
#   value = aws_instance.web[*].public_ip
# }

# output "public_ip_2" {
#   value = aws_instance.database[*].public_ip
# }