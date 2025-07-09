provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs = ["us-east-1a", "us-east-1b"]
}

module "sg" {
  source           = "../../modules/security_groups"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = "3.85.171.166/32"
}

module "web" {
  source         = "../../modules/ec2_asg"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnets
  ec2_sg_id      = module.sg.ec2_sg_id
  alb_sg_id      = module.sg.alb_sg_id
  instance_type  = "t2.micro"
}