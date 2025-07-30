provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners  = ["099720109477"]
  filter {
    name  = "name"
    values = [var.ubuntu_ami_name]
  }
}


module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.az
  env                 = var.env 
}

module "sg" {
  source           = "./modules/security_groups"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr   # for ssh to ec2
  env                 = var.env 
}

module "web" {
  source        = "./modules/ec2_asg"
  ami_id = data.aws_ami.ubuntu.id
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.public_subnets
  ec2_sg_id     = module.sg.ec2_sg_id
  alb_sg_id     = module.sg.alb_sg_id
  instance_type = var.instance_type
  key_name = var.key_name
  env           = var.env 
}