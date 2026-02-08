data "aws_ami" "ubuntu" {
  most_recent             = true

  filter {
    name                  = "name"
    values                = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name                  = "virtualization-type"
    values                = ["hvm"]
  }

  owners                  = ["099720109477"] # Canonical
}

resource "aws_instance" "terraform_ec2_instance" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.ec2_type
  subnet_id               = data.aws_subnet.default_subnet.id
  vpc_security_group_ids  = [resource.aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name      = var.key_pair_name

  tags = {
    Name                  = "terraform_ec2_instance"
  }

  root_block_device {
    volume_size = var.ebs_size # GiB
    volume_type = var.ebs_type 
  }
}