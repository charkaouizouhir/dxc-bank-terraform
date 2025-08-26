variable "sg_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "ingress_rules" {
  type = list(object({
    ip_protocol = string
    from_port   = string
    to_port     = string
    cidr_ipv4   = string
  }))
}