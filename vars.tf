variable "availability_zones" {
  type = list(string)
  default = ["us-west-2a","us-west-2b","us-west-2c"]
}
variable "cidr_blocks" {
  type = string
  default = "10.10.0.0/16"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {default = "us-west-2"}
// https://cloud-images.ubuntu.com/locator/ec2/
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-09cd747c78a9add63"
    us-east-2 = "ami-0cefaebb6da6ffd7f"
    us-west-2 = "ami-00712dae9a53f8c15"
    us-west-1 = "ami-0d221cb540e0015f4"
  }
}
// For keys
variable "PATH_TO_PRIVATE_KEY" { default = "keys/mykey" }
variable "PATH_TO_PUBLIC_KEY" { default = "keys/mykey.pub" }
variable "INSTANCE_USERNAME" { default = "ubuntu" }