# Creates auto scaling group for basion host on maltiple AZ.
resource "aws_launch_template" "linux" {
  name                   = var.template_name
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key

  tags = {
    template_terraform = var.template_name
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnets_ids

  launch_template {
    id      = aws_launch_template.linux.id
    version = "$Latest"
  }
}

resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow ssh from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow http from everywhere"
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
    Name = "sg-bastion"
  }
}
