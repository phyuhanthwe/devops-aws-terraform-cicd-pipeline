resource "aws_security_group" "demo-sg" {
  name   = "demo-sg"
  vpc_id = aws_vpc.custom-demo-vpc.id
  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.demo-sg.id
  ip_protocol       = "tcp"
  # will get ip from github secrets
  cidr_ipv4         = "${var.my-ip}/32"
  from_port         = "22"
  to_port           = "22"
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  security_group_id = aws_security_group.demo-sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "3000"
  to_port           = "3000"
}

resource "aws_vpc_security_group_egress_rule" "allow-outbound" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.demo-sg.id
  cidr_ipv4         = "0.0.0.0/0"
}