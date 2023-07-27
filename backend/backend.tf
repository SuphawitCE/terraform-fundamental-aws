terraform {
  backend "s3" {
    key        = "terraform/tfstate.tfstate"
    bucket     = "tf-remote-backend-2020"
    region     = "ap-southeast-1"
    access_key = "" # AWS_ACCESS_KEY
    secret_key = "" # AWS_SECRET_KEY
    # cat ~/.aws/credentials
  }
}
