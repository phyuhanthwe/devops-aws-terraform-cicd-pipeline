resource "aws_key_pair" "demo-key_pair" {
  key_name   = "demo-key-pair"
  public_key = file("~/.ssh/aws-demo.pub")
}
