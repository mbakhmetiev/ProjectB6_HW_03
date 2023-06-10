resource "aws_instance" "vm2-ubu" {
  ami                    = data.aws_ami.ubu22.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.app.key_name

  tags = {
    Name = "vm2-ubu"
  }
}

resource "aws_instance" "vm3-aws" {
  ami                    = data.aws_ami.amz_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.app.key_name

  tags = {
    Name = "vm3-aws"
  }
}
resource "aws_key_pair" "app" {
  key_name   = "ansible-key"
  public_key = data.local_file.pub_key.content
}

resource "aws_security_group" "app" {
  name = "terraform-nodes-instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "hosts" {
  content = templatefile("${path.module}/hosts.tpl",
    {
      vm2 = aws_instance.vm2-ubu.*.public_ip
      vm3 = aws_instance.vm3-aws.*.public_ip
    }
  )
  filename = "../ansible/inventory"
}