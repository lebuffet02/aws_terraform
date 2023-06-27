provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "tf-key-pair" {
  key_name = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair.pem"
}

resource "aws_instance" "example" {
  ami           = "ami-007855ac798b5175e" # Ubuntu 22.04 LTS
  instance_type = "t2.micro"
  key_name = "tf-key-pair"

  tags = {
    Name = "terraform-example-instance"
  }
}
