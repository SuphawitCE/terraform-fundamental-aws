# Managing multiple variables files in Terraform

Run `test.tfvars`
```tf
terraform plan -var-file=test.tfvars
```

Run `prod.testvars`
```tf
terraform plan -var-file=prod.tfvars
```