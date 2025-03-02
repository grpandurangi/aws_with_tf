provider "aws" {
  region = "us-east-1"
}


data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["project-subnet-public1-us-east-1a"]
  }
}


data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_security_group" "access_security_group" {
  name        = "ssh_https"
  description = "This firewall allows SSH, HTTP and MYSQL"
  vpc_id      = var.vpc_id

  dynamic "ingress" {

    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.access_security_group.id]
  key_name               = "grpmain"

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
}

resource "aws_eip" "elasticip" {
  instance = aws_instance.webserver.id
}

