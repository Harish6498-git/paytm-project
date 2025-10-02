terraform {
  backend "s3" {
    bucket         = "paytm-terraform-state-bucket"   # 🔹 Replace with your S3 bucket name
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "paytm-terraform-locks"          # 🔹 Replace with your DynamoDB table name
    encrypt        = true
  }
}

