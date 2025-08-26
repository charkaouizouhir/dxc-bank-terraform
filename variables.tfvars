# VPC
vpc_name = "dxc-bank-vpcc"
vpc_cidr = "10.0.0.0/16"

# Subnets
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]

# Availability Zones
az = ["us-east-1a", "us-east-1b"]

# Security Groups
ec2_sg_name = "dex-bank-ec2-sg"
alb_sg_name = "dxc-bak-alb-sg"

# EC2 Security Group Ingress Rules
ec2_ingress_rules = [
  # SSH
  {
    ip_protocol = "tcp"
    from_port   = "22"
    to_port     = "22"
    cidr_ipv4   = "0.0.0.0/0"
  },
  # HTTP
  {
    ip_protocol = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_ipv4   = "0.0.0.0/0"
  },
  # Kubernetes API Server
  {
    ip_protocol = "tcp"
    from_port   = "6443"
    to_port     = "6443"
    cidr_ipv4   = "0.0.0.0/0"
  },
  # NodePort Range for Services
  {
    ip_protocol = "tcp"
    from_port   = "30000"
    to_port     = "32767"
    cidr_ipv4   = "0.0.0.0/0"
  },
  # Internal Communication for kubelet & etcd
  {
    ip_protocol = "tcp"
    from_port   = "10250"
    to_port     = "10255"
    cidr_ipv4   = "0.0.0.0/0"
  }
]

# ALB Security Group Ingress Rules
alb_ingress_rules = [
  {
    ip_protocol = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_ipv4   = "0.0.0.0/0"
  }
]

# EC2 Instance
ec2_name      = "dxc-k8s"
instance_type = "t3.medium"
ami           = "ami-0610b52066a224f49"
key_name      = "ssh-key"

# Enable Public IP for EC2
enable_public_ip_address = true
