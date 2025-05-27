terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.0"
}


# Cria bucket S3
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  # (Opcional) política para impedir deleção acidental
  force_destroy = false
}

# Cria usuário IAM para acessar o bucket
resource "aws_iam_user" "s3_user" {
  name = "s3-access-user"
}

# Cria access key para o usuário IAM
resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

# Política com permissão básica para bucket S3
data "aws_iam_policy_document" "s3_user_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}

# Anexa a política no usuário IAM
resource "aws_iam_policy" "s3_user_policy" {
  name   = "s3-user-policy"
  policy = data.aws_iam_policy_document.s3_user_policy.json
}

resource "aws_iam_user_policy_attachment" "attach_s3_policy" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_user_policy.arn
}
