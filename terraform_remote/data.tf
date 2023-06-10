data "aws_ami" "ubu22" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

data "aws_ami" "amz_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230517.1-kernel-6.1-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "local_file" "pub_key" {
  filename = "/home/mbakhmetiev/.ssh/id_rsa.pub"
}
