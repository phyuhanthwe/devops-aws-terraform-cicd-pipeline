resource "aws_instance" "demo-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.demo-key_pair.key_name
  subnet_id                   = aws_subnet.custom-demo-subnet.id
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]
  associate_public_ip_address = true

  user_data = file("${path.root}/../scripts/install-docker.sh")

  tags = {
    Name = "${var.prefix}-instance"
  }
}