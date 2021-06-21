resource "aws_iam_role" "yoshiko_codedeploy" {
  name = "yoshiko-codedeploy-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "yoshiko_codedeploy" {
  role       = aws_iam_role.yoshiko_codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "yoshiko_test" {
  name = "yoshiko-test-${var.env}"
}

resource "aws_codedeploy_deployment_group" "yoshiko_test_grp" {
  app_name              = aws_codedeploy_app.yoshiko_test.name
  deployment_group_name = "yoshiko-test-grp-${var.env}"
  service_role_arn      = aws_iam_role.yoshiko_codedeploy.arn

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = aws_instance.app_server.tags.Name
  }
}

resource "aws_s3_bucket" "cdl_lambda" {
  bucket = "yoshiko-codedeploy"
  acl    = "private"

  tags = {
    Name        = "codedeploy repository"
    Environment = var.env
  }

  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "yoshiko_ec2_codedeploy_conf" {
  statement {
    sid = "S3GetAndList"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::yoshiko-codedeploy/${var.env}/*"
    ]
  }
}

resource "aws_iam_policy" "yoshiko_ec2_codedeploy" {
  name        = "yoshiko-ec2-codedeploy-${var.env}"
  description = "codedeploy ec2 resource"
  policy      = data.aws_iam_policy_document.yoshiko_ec2_codedeploy_conf.json
}
