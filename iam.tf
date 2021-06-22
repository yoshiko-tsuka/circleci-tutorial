resource "aws_iam_policy" "circleci_codedeploy_policy" {
  name        = "circleci_codedeploy_policy"
  description = "codedeploy policy"
  policy      = data.aws_iam_policy_document.circleci_codedeploy.json
}

resource "aws_iam_user_policy_attachment" "circleci_codedeploy-attach" {
  user       = var.circleci_user
  policy_arn = aws_iam_policy.circleci_codedeploy_policy.arn
}

data "aws_iam_policy_document" "circleci_codedeploy" {
  statement {
    sid = "S3GetAndList"
    actions = [
      "autoscaling:*",
      "codedeploy:*",
      "ec2:*",
      "lambda:*",
      "ecs:*",
      "elasticloadbalancing:*",
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteInstanceProfile",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile", 
      "s3:*",
      "ssm:*"
    ]
    resources = [
      "*"
    ]
  }
}

