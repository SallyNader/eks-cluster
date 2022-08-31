resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key" {
  key_name   = var.key_name
  public_key = trimspace(tls_private_key.key.public_key_openssh)
}

resource "local_file" "ssh_key" {
  filename        = "${var.key_name}.pem"
  file_permission = "0400"
  content         = tls_private_key.key.private_key_pem
}