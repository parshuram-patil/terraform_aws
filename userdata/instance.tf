resource "aws_instance" "example" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  # user data
  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "linux server"
  }

  volume_tags = var.tag

}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "eu-west-1a"
  size              = 9
  type              = "gp2"
  tags = {
    Name = "extra volume1 data"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = var.EBS_DEVICE_NAME_1
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.example.id
  skip_destroy = true
}


resource "aws_ebs_volume" "ebs-volume-2" {
  availability_zone = "eu-west-1a"
  size              = 10
  type              = "gp2"
  tags = {
    Name = "extra volume2 data"
  }
}

resource "aws_volume_attachment" "ebs-volume-2-attachment" {
  device_name = var.EBS_DEVICE_NAME_2
  volume_id   = aws_ebs_volume.ebs-volume-2.id
  instance_id = aws_instance.example.id
  skip_destroy = true
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

resource "aws_instance" "win_server" {
  ami           = "ami-07c8a3a59f2f7305b"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-rdp.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-win.rendered

  tags = {
    Name = "win server"
  }

  volume_tags = var.tag
}

resource "aws_ebs_volume" "ebs-volume-win-1" {
  availability_zone = "eu-west-1a"
  size              = 10
  type              = "gp2"
  tags = {
    Name = "win server volume 1"
  }
}

resource "aws_volume_attachment" "ebs-volume-attachment-win-1" {
  device_name = var.EBS_DEVICE_NAME_1
  volume_id   = aws_ebs_volume.ebs-volume-win-1.id
  instance_id = aws_instance.win_server.id
  skip_destroy = true
}

resource "aws_ebs_volume" "ebs-volume-win-2" {
  availability_zone = "eu-west-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "win server volume 2"
  }
}

resource "aws_volume_attachment" "ebs-volume-attachment-win-2" {
  device_name = var.EBS_DEVICE_NAME_2
  volume_id   = aws_ebs_volume.ebs-volume-win-2.id
  instance_id = aws_instance.win_server.id
  skip_destroy = true
}

output "windows_public_ip" {
  value = aws_instance.win_server.public_ip
}