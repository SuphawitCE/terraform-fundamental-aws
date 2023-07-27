provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "test" {
  cidr_blocks = "10.0.0.0/16"
}

