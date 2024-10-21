resource "aws_eks_cluster" "api" {
  name     = "${var.prefix}-api-cluster"
  role_arn = aws_iam_role.api.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "api" {
  cluster_name    = aws_eks_cluster.api.name
  node_group_name = "${var.prefix}-api-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}
