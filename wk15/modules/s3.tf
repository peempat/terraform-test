#local modules

module "s3_bucket" {
  source            = "./modules/s3_bucket"
  bucket_name       = var.bucket_name    # เปลี่ยนชื่อนี้เป็นชื่อ bucket 
  upload_file_source = var.upload_file_source # path ไปยังไฟล์รูปภาพ
  upload_file_key    = var.upload_file_key    # S3 key ที่ต้องการ (ไฟล์ path ใน S3)
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "uploaded_file_url" {
  value = module.s3_bucket.file_url
}
