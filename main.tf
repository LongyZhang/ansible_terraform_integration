provider "aws" {
  region = "us-east-1"  # Change if you're in a different region
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

# RHEL 8 AMI from AWS Marketplace (for us-east-1)
data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]  # Red Hat official

  filter {
    name   = "name"
    values = ["RHEL-8*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "main-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"  # Adjust as needed
  tags = { Name = "public-subnet" }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "ssh_sg" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_sg" {
  name   = "allow access from subnet"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")  # adjust path as needed
} 

# List of node names
locals {
  instance_names = [
    "manager",
    "test",
    "web1",
    "web2",
    "proxy",
    "database"
  ]
}

resource "aws_instance" "nodes" {
  count         = length(local.instance_names)
  ami           = data.aws_ami.rhel.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id,aws_security_group.vpc_sg.id]

  tags = {
    Name = local.instance_names[count.index]
  }
}
