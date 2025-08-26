variable "ec2_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "ami" {
  type = string
}
variable "ec2_sg_id" {
  type = list(string)
}
variable "alb_sg_id" {
  type = list(string)
}

variable "key_name" {
  type = string
}
variable "enable_public_ip_address" {
  type = bool
}

variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
