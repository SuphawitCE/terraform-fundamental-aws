## Linting
We use TFLint for automated code checks. And checkov for static analysis security scanning.

## Formatting
Always use terraform fmt to rewrite Terraform configuration files to a canonical format and style.

## Naming
Use snake_case in all: resource names, data source names, variable names, outputs.

There is an exception for the above elements if any of them ending with pre-production environment:

```tf
name for staging environment will be <resource>_staging
name for staging environment will be <resource>_pre-production (NOT <resource>_pre_production)
name for staging environment will be <resource>_production
```

- Only use lowercase letters and numbers.
- Always use singular noun for names.
- Always use double quotes.

## Resource and data source arguments
Do not repeat resource type in resource name (not partially, nor completely)

```tf
// Good
resource "aws_route_table" "public" {}

// Bad
resource "aws_route_table" "public_route_table" {}

// Bad
resource "aws_route_table" "public_aws_route_table" {}
```

- Resource name should be named this if there is no more descriptive and general name available, or if the resource module creates a single resource of this type (eg, there is a single resource of type aws_nat_gateway and multiple resources of type aws_route_table, so aws_nat_gateway should be named this and aws_route_table should have more descriptive names
- like private, public, database). Normally, we use this to delegate the output of a module with the resource itself.

```tf
# modules/pomelo_alb/main.tf
resource "aws_lb" "pomelo" {
  name               = "${var.name}"
  load_balancer_type = "application"
  security_groups    = ["${var.vpc_security_group_ids}"]
  subnets            = ["${var.subnets}"]
}

# modules/pomelo_alb/outputs.tf
output "this_dns" {
  description = "Pomelo Application loadbalancer DNS"
  value       = "${aws_lb.pomelo.dns}"
}

# main.tf
module "pomelo_alb" {
  source = "./modules/pomelo_alb"
  ...
}
# Get the DNS by `module.pomelo_alb.this_dns`
```

- Include the tags argument, if supported by resource as the last real argument, following by depends_on and lifecycle, if necessary. All of these should be separated by a single empty line.

```tf
resource "aws_nat_gateway" "pomelo" {
  count         = "1"

  allocation_id = "..."
  subnet_id     = "..."

  tags = {
    Name = "..."
  }

  depends_on = ["aws_internet_gateway.this"]

  lifecycle {
    create_before_destroy = true
  }
}


Include the count argument inside of resource blocks as the first argument at the top and separate by a newline.
resource "aws_route_table" "public" {
  count  = "2"

  vpc_id = "vpc-12345678"
  ....
}
```


When using a condition as the count arguments value, use a boolean value, if it makes sense, otherwise use length or other interpolation.

```tf
count = "${var.create_public_subnets}"


count = "${length(var.public_subnets) > 0 ? 1 : 0}"
```

To make inverted conditions don’t introduce another variable unless really necessary, use 1 - boolean value instead.

```tf
count = "${1 - var.create_public_subnets}"
```

NOTE: terraform modules don’t support count parameter currently. You can follow up this ticket for updates: https://github.com/hashicorp/terraform/issues/953

Variables
- Don’t reinvent the wheel in resource modules - use the same variable names, description and default as defined in “Argument Reference” section for the resource you are working on.
- Omit type = "string" declaration if there is default = "" also
- Omit type = "list" declaration if there is default = [] also.
- Omit type = "map" declaration if there is default = {} also.
- Use the plural form in name of variables of type list and map.
- When defining variables order the keys: description, type, default.


## Outputs

Output names are important, use them consistent and understandable outside of its scope (when the user is using a module it should be obvious what type and attribute of the value is returned).

- The general recommendation for the names of outputs is that it should be descriptive for the value it contains and be less free-form than you would normally want.
- If the output is returning a value with interpolation functions and multiple resources, the {name} and {type} there should be as generic as possible (this is often the most generic and should be preferred).

```tf
// Good
output "this_security_group_id" {
  description = "The ID of the security group"
  value       = "${element(concat(coalescelist(aws_security_group.this.*.id, aws_security_group.this_name_prefix.*.id), list("")), 0)}"
}

// Bad
output "security_group_id" {
  description = "The ID of the security group"
  value       = "${element(concat(coalescelist(aws_security_group.this.*.id, aws_security_group.web.*.id), list("")), 0)}"
}
```

output "another_security_group_id" {
  description = "The ID of web security group"
  value       = "${element(concat(aws_security_group.web.*.id, list("")), 0)}"
}


If the returned value is a list its name should be plural.

```tf
output "this_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = ["${aws_rds_cluster_instance.this.*.endpoint}"]
}
```

## Main File Structure
Order by top to bottom in terms of execution

```tf
// Create VPC first
resource "aws_vpc" "pomelo" {}

// Create IAM role before the EC2 instance
resource "aws_iam_role" "pomelo_api" {}

// Create EC2 instance
resource "aws_instance" "pomelo_api" {}
Project Structure
```

```tf
terraform-project
├─ modules
│  ├─ module_1
│  │  ├─ main.tf
│  │  ├─ outputs.tf
│  │  ├─ variables.tf
│  └─ module_2
│     ├─ main.tf
│     ├─ outputs.tf
│     └─ variables.tf
│
├─ main.tf
├─ outputs.tf
├─ variables.tf
│
├─ staging.tfvars
├─ production.tfvars
│
└─ README.md
```

- module: Module is a collection of connected resources which together perform the common action (eg: aws_vpc creates VPC, subnets, NAT, etc)
- main.tf: Call modules, locals and data sources to create all resources
- variables.tf: contains declarations of variables used in main.tf
- outputs.tf: contains outputs from the resources created in main.tf
- staging.tfvars: Configuration for Staging (like instance type,...)
- production.tfvars: Configuration for Production (like instance type,...)
**NOTE**: It is easier and faster to work with a smaller number of resources (in the main file also in the module as well), terraform plan and terraform apply both make cloud API calls to verify the status of resources, if you have your entire infrastructure in a single composition this can take many minutes.

## Best Practices
Use shared modules

Manage terraform resources with shared modules, this will save a lot of coding time. No need re-invent the wheel!

- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform Registry](https://registry.terraform.io/)

State store
Always using Remote state
** Start your project with AWS S3 💯

```tf
terraform {
  backend "s3" {
    region  = "aws_region"
    # This bucket needs to be created beforehand
    bucket  = "bucket_name"
    key     = "aws-setup/state.tfstate"
    encrypt = true # AES-256 encryption
  }
}
```

NOTE: Enable version control on this bucket. And set IAM Policy to limit the access read/write to that bucket.

** Start your project with Terraform Cloud Remote State Management 💯

**Do not store the `tfstate` in Git** as it includes sensitive data.

## Security
- Using backend S3, set IAM policy to limit the access to that bucket.
- Don’t hardcode sensitive data (password, ssh key,…) in the Terraform code or in the varfile, don’t push it to Git, define sensitive data on fly (terraform plan or terraform apply) or using Vault Provider to deal with sensitive data.
- Prefer to use cloud-init instead of bash scripts.