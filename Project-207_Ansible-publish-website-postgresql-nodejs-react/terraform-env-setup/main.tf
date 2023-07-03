terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"

    }
    
}
}

provider "aws" {
    region = "us-east-1"
    }

resource "aws_instance" "nodes" {
    ami = var.myami
    instance_type = var.controlinstancetype
    key_name = var.mykey
    iam_instance_profile = aws_iam_instance_profile.ec2full.name 
    vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
    tags = {
        Name = "ansible-control"
        stack = "ansible-project"
    }
}

resource "aws_instance" "nodes" {
    ami = var.myami
    instance_type = var.instancetype
    count = var.num
    key_name = var.mykey
    vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
    tags = {
        Name = "ansible_${element(var.tags, count.index )}"
        stack = "ansible_project"
        environment = "development"
    }
    user_data = file("userdata.sh")
}

resource "aws_iam_role" "ec2full" {
    name = "projectec2full-${var.user}"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
}

resource "aws_iam_instance_profile" "ec2full" {
    name = "projectec2full-${var.user}"
    role = aws_iam_role.ec2full.name
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "tf-sec-gr" {
  name        = "${var.mysecgr}-${var.user}"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = var.mysecgr
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

    ingress {
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

    ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

    ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}