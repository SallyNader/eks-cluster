# Creates eks cluster role.
resource "aws_iam_role" "eks-iam-role" {
  name               = "eks-iam-role"
  path               = "/"
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
      {
      "Effect": "Allow",
      "Principal": {
          "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      }
      ]
    }
  EOF
}

# Creates worker nodes role.
resource "aws_iam_role" "worker-nodes" {
  name               = "eks-worker-nodes-role"
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
      {
      "Effect": "Allow",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      }
      ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name

}

resource "aws_iam_role_policy_attachment" "container-registry-readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "ec2-for-image-builder" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "ec2-container-registry-readOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-nodes.name
}