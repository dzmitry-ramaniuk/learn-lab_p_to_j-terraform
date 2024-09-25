provider "aws" {
  region = "eu-central-1"
}

# Config to create shared state for terraform in s3 and dynamodb table
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-lab-dr-2024"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-lab-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Config to store the state in s3 and lock it with dynamodb
terraform {
  backend "s3" {
    bucket = "terraform-state-lab-dr-2024"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-state-lab-locks"
    encrypt        = true
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_locks.arn
  description = "The ARN of the DynamoDB table"
}

module "cognito" {
  source = "./cognito"
}

module "dynamodb" {
  source = "./dynamodb"
}