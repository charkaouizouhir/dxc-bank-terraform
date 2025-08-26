resource "aws_security_group" "sg" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "security group for ${var.sg_name}"
}
resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  for_each          = { for index, rule in var.ingress_rules : index => rule }
  security_group_id = aws_security_group.sg.id
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
}
