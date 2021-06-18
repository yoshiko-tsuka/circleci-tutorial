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
