resource "aws_instance" "bastion_host" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  tags = {
    Name = "bastion_host"
  }

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

resource "aws_instance" "db_server" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  tags = {
    Name = "db_server"
  }

  # the VPC subnet
  subnet_id = aws_subnet.main-private-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.db-sg.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
}

