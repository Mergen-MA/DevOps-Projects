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