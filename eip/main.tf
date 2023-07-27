provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
}

resource "aws_eip" "elasticeip" {
  instance = aws_instance.ec2.id
}

# Public IP
output "EIP" {
  value = aws_eip.elasticeip.public_ip
}
