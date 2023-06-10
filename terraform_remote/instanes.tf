resource "aws_instance" "vm2-ubu" {
  ami                    = data.aws_ami.ubu22.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.ansible.key_name

  tags = {
    Name = "vm2-ubu"
  }
}

resource "aws_instance" "vm3-aws" {
  ami                    = data.aws_ami.amz_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.ansible.key_name

  tags = {
    Name = "vm3-ubu"
  }
}
resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = data.local_file.pub_key.content
}

resource "aws_security_group" "instance" {
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