variable "vpc_id" {}
variable "private_subnets" {}
variable "alb_target_group_arn" {}
variable "sg_id" {}
variable "ami_id" {}
variable "instance_type" {}
#variable "instance_profile_name" {}
variable "min_size" {
  default = "2"
}
variable "max_size" {
  default = "4"
}
variable "desired_size" {
  default = "2"
}
variable "environment" {}

