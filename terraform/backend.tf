# =============================================================================
# Terraform Backend Configuration (S3 + DynamoDB)
# =============================================================================
# NOTE: Before first apply, create the S3 bucket and DynamoDB table manually
# or comment out this backend block for the initial run.

terraform {
  backend "s3" {
    bucket         = "laravel-pipeline-tfstate-067847734974"
    key            = "laravel-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "laravel-pipeline-tfstate-lock"
  }
}
