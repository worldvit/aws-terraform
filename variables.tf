variable "region" {
  type=string
  default = "us-west-2"
}

variable "ami" {
  type=string
  default = "ami-06068bc7800ac1a83"
}

variable "inst-type" {
  type = string
  default = "t2.micro"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/mykey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "keys/mykey"
}

variable "instance-username" {
  default = "ubuntu"
}

variable "management-sg" {
  type = map(object({
    description = string
    port = number
    protocol = string
    cidr_blocks = list(string)
  }))

  default = {
    "22" = {
      description = "Allowd SSH for admin"
      port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "80" = {
      description = "Allowd HTTP for web clients"
      port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "443" = {
      description = "Allowd HTTPS for web clients"
      port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "1521" = {
      description = "Allowd Oracle for admin"
      port = 1521
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "3389" = {
      description = "Allowd RDP for admin"
      port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "53" = {
      description = "Allowd domain for everyone"
      port = 53
      protocol = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}