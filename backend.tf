/*
terraform {
  backend "s3" {
  bucket = "kevinkwangjinkim-terraform-state-001"
  region = "us-west-2"
  key = "keys"
  shared_credentials_file = "~/.aws/credentials" 
  profile = "kevinprofile"
 }
}
*/
terraform { 
    backend "local" { } 
}