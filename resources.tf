# Data section
data "aws_iam_policy" "Administrator_Access" {
  name="AdministratorAccess"
}

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

# Create users
/*
resource "aws_iam_user" "adam" {
  name = "adam.god"
}

resource "aws_iam_user" "eve" {
  name = "eve"

  tags = {
    Name = "Eve"
  }
}
*/

resource "aws_iam_user" "managers" {
  count = length(var.users)
  name = var.users[count.index]

  tags = {
    Name = var.users[count.index]
  }
}

# Create a group
resource "aws_iam_group" "devops" {
  name="devops"
}

# attach policy to group
resource "aws_iam_group_policy_attachment" "attach" {
  group=aws_iam_group.devops.name
  policy_arn = data.aws_iam_policy.Administrator_Access.arn
}

resource "aws_iam_group_membership" "devops" {
    name = aws_iam_group.devops.name
    count = length(var.users)
    users = [
        aws_iam_user.managers[count.index].name
    ]
    group = aws_iam_group.devops.name
}

# Create s3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket = "terraform-kdigital-shop-20240604-1"
}

# Create an instance
resource "aws_instance" "web" {
#   ami = "ami-06068bc7800ac1a83"
  # ami = var.ami
  count = 3
  ami = data.aws_ami.amazon-linux.id
  instance_type = var.inst-type
  key_name = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [ aws_security_group.management.id ]

  tags = {
    Name = "web-${count.index}"
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
resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}