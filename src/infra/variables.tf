variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "springboot-s3-bucket-file-storage"
}

variable "subnet_ids" {
  description = "IDs das subnets onde o EKS vai rodar"
  type        = list(string)
}

variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "app-s3-cluster"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "eks_version" {
  default = "1.29"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}


