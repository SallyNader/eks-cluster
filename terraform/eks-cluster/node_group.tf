# Nodes in private subnets.
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.node_group_name}-private"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.private_node_template.id
    version = "$Latest"
  }
  
  scaling_config {
    desired_size = var.pvt_desired_size
    max_size     = var.pvt_max_size
    min_size     = var.pvt_min_size
  }
  
  tags = {
    Name = "${var.node_group_name}-private"

  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
    aws_launch_template.private_node_template,
  ]
}

# Nodes in public subnet.
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.node_group_name}-public"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.public_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  remote_access {
    ec2_ssh_key = var.key_name
  }
  scaling_config {
    desired_size = var.pblc_desired_size
    max_size     = var.pblc_max_size
    min_size     = var.pblc_min_size
  }

  tags = {
    Name = "${var.node_group_name}-public"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}

resource "aws_launch_template" "private_node_template" {
  name = "private-node-template"
  instance_type = var.instance_type
  key_name = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      delete_on_termination = true
      volume_type = "gp2"
    }
  }
 

  tags = {
    template_terraform = "private_node_template"
  }
}