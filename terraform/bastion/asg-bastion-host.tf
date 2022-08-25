# Creates auto scaling group for basion host on maltiple AZ.
resource "aws_launch_template" "linux" {
  name                 = "linux"
  image_id             = "ami-0022f774911c1d690"
  instance_type        = "t2.micro"
  security_group_names = ["bastion"]
  key_name             = aws_key_pair.deployer

  tags = {
    template_terraform = "linux"
  }
}

resource "aws_autoscaling_group" "web" {
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity   = 3
  max_size           = 4
  min_size           = 3
  launch_template {
    id      = aws_launch_template.linux.id
    version = "$Latest"
  }
  tag {
    key = "bastion-hosts"
  }
}

resource "aws_security_group" "bastion" {
  name   = "Bastion"
  vpc_id = module.vpc.vpc_main.id

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