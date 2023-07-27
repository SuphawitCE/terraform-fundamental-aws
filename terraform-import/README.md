# Import file in Terraform

```tf
provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
```

1. Run `terraform init`
2. Run `terraform apply`
3. Add resource `myvpc2`
4. RUn `terraform import aws_vpc.myvpc2 <id>`