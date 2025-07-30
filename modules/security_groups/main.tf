# Allow HTTP trafic from internet to load balancer
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  description = "Allow HTTP traffic from internet"  
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  tags = {
    Name = "alb-sg-${var.env}"
  }

}

# Allow SSH trafic from cidr & HTTP traffic from loadbalancer
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  description = "Allow SSH from CIDR"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  tags = {
    Name = "ec2-sg-${var.env}"
  }

}

