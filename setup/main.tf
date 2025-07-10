provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "terraform_sg" {
  name        = "terraform-ssh-access"
  description = "Allow SSH access"

  ingress {
    description = "SSH from local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.244.155.136/32"] # Access from MyIP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allowed all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-SG"
  }
}


resource "aws_instance" "terraform_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.terraform_key
  user_data              = file("${path.module}/userdata.sh")
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  tags = {
    Name = "Terraform-Server"
  }

}
