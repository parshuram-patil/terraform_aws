resource "aws_instance" "server_1" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = local.subnet_1
  vpc_security_group_ids = [local.sg_http, local.sg_ssh]
  key_name               = local.key_name
  tags = {
    Name = "linux server 1"
  }
}

resource "aws_instance" "server_2" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = local.subnet_1
  vpc_security_group_ids = [local.sg_http, local.sg_ssh]
  key_name               = local.key_name
  tags = {
    Name = "linux server 2"
  }
}