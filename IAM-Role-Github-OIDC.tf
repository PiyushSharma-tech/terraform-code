resource "aws_iam_role" "github_oidc_role" {
  name               = "GitHubOIDCRole"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role_policy.json
}

data "aws_iam_policy_document" "github_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]  # Replace with your AWS account ID
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:your-github-username/your-repo-name:ref:refs/heads/main"]  # Adjust as necessary
    }
  }
}

resource "aws_iam_role_policy" "github_oidc_policy" {
  name   = "GitHubOIDCPolicy"
  role   = aws_iam_role.github_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}