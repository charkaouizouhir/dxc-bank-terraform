resource "aws_launch_template" "ec2_template" {
  name          = "${var.ec2_name}-launch_template"
  instance_type = var.instance_type
  image_id      = var.ami
  key_name      = var.key_name
  network_interfaces {
    security_groups             = var.ec2_sg_id
    associate_public_ip_address = var.enable_public_ip_address
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.ec2_name
    }
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "${var.ec2_name}-lb-target-group"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb" "alb" {
  name               = "${var.ec2_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_id
  subnets            = var.subnet_ids

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.ec2_name}-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.lb_target_group.arn]

  tag {
    key                 = "Name"
    value               = var.ec2_name
    propagate_at_launch = true
  }
}