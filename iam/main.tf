provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_iam_user" "myUser" {
  name = "TJ"
}

resource "aws_iam_policy" "customPolicy" {
  name = "GlacierEFSEC2"

  policy = <<EOF
  {
    Your IAM Polices
  }
  EOF
}

resource "aws_iam_policy_attachment" "policyBind" {
  name       = "attachment"
  users      = [aws_iam_user.myUser.name]
  policy_arn = aws_iam_policy.customPolicy.arn
}
