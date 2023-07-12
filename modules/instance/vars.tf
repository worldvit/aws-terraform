variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/mykey.pub" #위치는 root-module에서 참조할때 위치이다.
}
variable ec2_name {
  type = list(string)
  default = ["k8s-cp","k8s-n1","k8s-n2"]
}
