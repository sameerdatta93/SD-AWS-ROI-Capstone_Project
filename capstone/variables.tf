variable "region" {
  default = "us-east-1"
  type = string
}
variable "userdata_git_repo" {}
variable "ami_id" {}
variable "instance_type" {
 default = "t2.micro"
}
