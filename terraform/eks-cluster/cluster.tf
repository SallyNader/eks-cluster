# Creates eks cluster.
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-iam-role.arn
  vpc_config {
    subnet_ids = [for subnet in var.cluster_subnets_ids : subnet]
  }
  depends_on = [
    aws_iam_role.eks-iam-role
  ]
}


# Creates worker nodes.
resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_role_arn   = aws_iam_role.worker-nodes.arn
  subnet_ids      = var.subnets_ids

  launch_template {
    id      = aws_launch_template.linux-eks-nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cni-policy,
    aws_iam_role_policy_attachment.container-registry-readonly,
    var.nfs
  ]
}

resource "aws_launch_template" "linux-eks-nodes" {
  name                 = var.template_name
  image_id             = var.image_id
  instance_type        = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg-worker-node.id]
  key_name             = var.key_name


  tags = {
    template_terraform = var.template_name
  }

  depends_on = [
    var.nfs
  ]
}


resource "aws_security_group" "sg-worker-node" {
  name        = "Worker nodes allow bastion host"
  description = "Allow only bastion host to access kubernetes instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ssh from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_id]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}
