provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs = var.az
  tags = var.tag_vpc
}

module "sg" {
  source           = "../../modules/security_groups"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
 
}

module "web" {
  source         = "../../modules/ec2_asg"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnets
  ec2_sg_id      = module.sg.ec2_sg_id
  alb_sg_id      = module.sg.alb_sg_id
  instance_type  = var.instance_type
}