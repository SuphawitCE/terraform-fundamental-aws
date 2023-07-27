provider "aws" {
  region = "ap-southeast-1"
}

module "ec2module" {
  source  = "./ec2"
  ec2name = "Name From Module"
}

output "module_output" {
  value = module.ec2module.instance_id
}
