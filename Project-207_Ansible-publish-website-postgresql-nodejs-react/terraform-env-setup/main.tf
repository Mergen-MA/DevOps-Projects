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
}