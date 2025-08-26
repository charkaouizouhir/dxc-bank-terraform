variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidr" {
  type = list(string)
}
variable "private_subnet_cidr" {
  type = list(string)
}
variable "az" {
  type = list(string)
}
variable "ec2_sg_name" {
  type = string
}
variable "alb_sg_name" {
  type = string
}
variable "ec2_ingress_rules" {
  type = list(object({
    ip_protocol = string
    from_port   = string
    to_port     = string
    cidr_ipv4   = string
  }))
}
variable "alb_ingress_rules" {
  type = list(object({
    ip_protocol = string
    from_port   = string
    to_port     = string
    cidr_ipv4   = string
  }))
}

variable "ec2_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "ami" {
  type = string
}
variable "key_name" {
  type = string
}
variable "enable_public_ip_address" {
  type = bool
}