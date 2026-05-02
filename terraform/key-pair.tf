resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo-key_pair" {
  key_name   = "demo-key-pair"
  public_key = tls_private_key.rsa-key.public_key_openssh
}

resource "local_file" "ssh-private-key" {
  content         = tls_private_key.rsa-key.private_key_openssh
  filename        = "${path.root}/generated-key/${var.prefix}-key.pem"
  file_permission = "400"
}