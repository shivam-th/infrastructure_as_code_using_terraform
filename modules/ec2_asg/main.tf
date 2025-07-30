resource "aws_lb" "web_alb" {
  name               = "web-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "web-alb-${var.env}"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  tags = {
    Name = "web-tg-${var.env}"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  tags = {
    Name = "web-listener-${var.env}"
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-template-${var.env}"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name = var.key_name

  tags = {
    key  = "Name"
    name = "web-template-${var.env}"
  }
}


resource "aws_autoscaling_group" "web_asg" {
  name                = "terraform-asg-${var.env}"  
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.web_tg.arn]
  health_check_type = "EC2"

   tag {
    key                 = "Name"
    value               = "web-instance-${var.env}"
    propagate_at_launch = true                                      # applied to all EC2 instances
  }
}


