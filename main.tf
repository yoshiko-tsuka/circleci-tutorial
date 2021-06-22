terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.personal.id
  user_data     = file("${var.root_dir}/ec2/userdata/apache")
  vpc_security_group_ids = ["${aws_security_group.web_server.id}"]
  iam_instance_profile   = aws_iam_instance_profile.app_server.name
  tags = {
    Name = "WebServerInstance"
  }
}

resource "aws_iam_instance_profile" "app_server" {
  name = "app-server-profile"
  role = aws_iam_role.yoshiko_ec2_codedeploy.name
}

resource "aws_key_pair" "personal" {
  key_name   = "personal"
  public_key = file("~/.ssh/personal.pub")
}

resource "aws_security_group" "web_server" {
  name        = "web_server_security_group"
  description = "Used in the terraform web_server"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
