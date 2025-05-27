resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "app-s3-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]

  tags = {
    Name = "app-s3-node-group"
  }

  depends_on = [aws_eks_cluster.eks]
}
