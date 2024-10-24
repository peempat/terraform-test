#provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.region
}

#resource 
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # เปิดการใช้งาน versioning หากต้องการ
  versioning {
    enabled = true
  }

  # ตั้งค่า bucket เป็น private
  acl = "private"

  # เปิดการเข้ารหัสข้อมูล
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# upload pics to s3 bucket
resource "aws_s3_bucket_object" "example_file" {
  bucket = aws_s3_bucket.this.bucket
  key    = var.upload_file_key    # ไฟล์ path ใน S3 bucket
  source = var.upload_file_source # path ของไฟล์ในเครื่องที่จะอัปโหลด
  acl    = "private"
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "file_url" {
  value = aws_s3_bucket_object.example_file.id
}
