provider "aws" {
    region = "us-east-1"
}

variable "vpc_name" {
    name = "firstvpc"
}

resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    name = var.vpc_name
}