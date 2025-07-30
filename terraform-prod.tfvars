env    = "prod"
region = "us-east-1"

# instance
instance_type = "t3.medium"
key_name = "terraform-key"
ubuntu_ami_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"

#sg
allowed_ssh_cidr    = "103.244.155.136/32"

# VPC
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
az                  = ["us-east-1a", "us-east-1b"]






