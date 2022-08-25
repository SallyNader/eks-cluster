# Creates eks cluster.
resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn
  vpc_config {
    subnets = [for subnet in data.aws_subnet.default-subnet : subnet.id if contains(["us-east-1a", "us-east-1b", "us-east-1c"], subnet.availability_zone)]
  }
  depends_on = [
    aws_iam_role.eks-iam-role
  ]
}


# Creates worker nodes.
resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "worker-nodes"
  node_role_arn   = aws_iam_role.worker-nodes.arn
  subnet_ids      = module.vpc.private-subnet-output

  launch_template {
    id = aws_launch_template.linux-eks-nodes
    version = "$Latest"
  }

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }
  remote_access {
    ec2_ssh_key               = aws_key_pair.ec2-key.key_name
    source_security_group_ids = [aws_security_group.sg-worker-node.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cni-policy,
    aws_iam_role_policy_attachment.container-registry-readonly,
    aws_efs_file_system.efs
  ]
}

resource "aws_launch_template" "linux-eks-nodes" {
  name                 = "linux-eks-nodes"
  image_id             = "ami-0022f774911c1d690"
  instance_type        = "t2.micro"
  security_group_names = ["sg-worker-node"]
  key_name             = aws_key_pair.deployer

  user_data = filebase64("../../${path.module}/bash/script.sh")

  tags = {
    template_terraform = "linux-eks-nodes"
  }
  
  depends_on = [
    aws_efs_file_system.efs
  ]
}



resource "aws_security_group" "sg-worker-node" {
  name        = "Worker nodes allow bastion host"
  description = "Allow only bastion host to access kubernetes instances"
  vpc_id      = module.vpc_main.id

  ingress {
    description     = "Allow ssh from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}