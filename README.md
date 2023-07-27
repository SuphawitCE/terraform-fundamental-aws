# Terraform Fundamental for AWS and Guide

## Prerequisite

Before you begin, ensure you have met the following requirements:

- You have a Mac / Linux Workstation.
- You have installed the following software:
  - Terraform version >= `1.3.7`
  - `yor` (> `0.1.151`)

## Terraform common commands

Format and Validate Terraform code, format code per HCL canonical standard.
```tf
terraform fmt 
```

Initialize your Terraform working directory.
```tf
terraform init
```

Plan, Deploy and Cleanup Infrastructure.
```tf
terraform apply
```

Terraform Destroy command will instruct Terraform to terminate / destroy all the resources managed by the Terraform project. 
This will enable you to completely tear down and remove all resources defined in the Terraform project that have previously been deployed.
```tf
terraform destroy
```


## Contributing to `Terraform-Fundamental-aws`

To contribute to `Terraform-Fundamental-aws`, follow these steps:

1. Clone this repository.
2. Read [Running code quality checks](#quality-checks).
3. Create a feature branch: `git checkout -b <branch_name>`.
4. Make your changes and commit them: `git commit -m '<commit_message>'`
5. Push to the original branch: `git push origin <branch_name>`
6. Create the pull request against `master`.

**<a name="quality-checks"></a>Running code quality checks:**

To ensure the code quality of this project is kept consistent we make use of pre-commit hooks. To install them, run the commands below.

```bash
brew install pre-commit
pre-commit install --install-hooks -t pre-commit -t commit-msg
```

## Further reading
- [Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform Registry](https://registry.terraform.io/)
