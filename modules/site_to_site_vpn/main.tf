# Virtual Private Gateway
resource "aws_vpn_gateway" "vgw" {
  vpc_id = var.vpc_id
  amazon_side_asn = 64512
  tags = {
    Name = "dxc-bank-vpn-gateway"
  }
}

# 2️⃣ Customer Gateway
resource "aws_customer_gateway" "cgw" {
  bgp_asn = 65000          # ASN if using BGP
  ip_address = "196.200.140.3" 
  type = "ipsec.1"
  tags = {
    Name = "dxc-bank-customer-gateway"
  }
}

#  VPN Connection
resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type = "ipsec.1"
  
  # dynamic routing using BGP
  static_routes_only = false

  tags = {
    Name = "dxc-bank-site-to-site-vpn"
  }
}