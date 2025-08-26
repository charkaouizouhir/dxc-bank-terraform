module "networking" {
  source              = "./modules/networking"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
}

module "ec2_security_group" {
  source        = "./modules/SG"
  sg_name       = var.ec2_sg_name
  vpc_id        = module.networking.vpc_id
  ingress_rules = var.ec2_ingress_rules
}
module "alb_security_group" {
  source        = "./modules/SG"
  sg_name       = var.alb_sg_name
  vpc_id        = module.networking.vpc_id
  ingress_rules = var.alb_ingress_rules
}

module "compute" {
  source                   = "./modules/compute"
  ec2_name                 = var.ec2_name
  instance_type            = var.instance_type
  ami                      = var.ami
  key_name                 = var.key_name
  ec2_sg_id                = [module.ec2_security_group.sg_id]
  alb_sg_id                = [module.alb_security_group.sg_id]
  enable_public_ip_address = var.enable_public_ip_address
  subnet_ids               = module.networking.public_subnet_ids
  vpc_id                   = module.networking.vpc_id
}