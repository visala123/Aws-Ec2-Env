provider "aws" {
  region = var.region
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get Subnet by Name Tag
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

# Get Security Group by ID Tag
data "aws_security_group" "selected" {
  id = var.sg_id
}

# Get Key Pair
data "aws_key_pair" "selected" {
  key_name = var.key_name
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.selected.id]
  key_name                    = data.aws_key_pair.selected.key_name
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name = var.instance_name
  }
}
