provider "aws" {
    region = "us-east-1"
}

variable "vpc_name" {
    type = string
    default = "TerraformVPC"
}

resource "aws_vpc" "test" {
    cidr_block = "192.168.0.0/24"
    
    
    tags = {
    Name = var.vpc_name
  }
}