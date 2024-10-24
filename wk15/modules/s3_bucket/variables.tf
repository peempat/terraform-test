variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}
variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}
variable "aws_session_token" {
  type        = string
  description = "AWS Session Token"
  sensitive   = true
}
variable "key_name" {
  type        = string
  description = "Private key path"
  sensitive   = false
}
variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
  default     = "s3-bucket-127"
}

variable "upload_file_source" {
  description = "Path to the local image file to be uploaded to S3"
  type        = string
  default     = "./my-melody.jpg"
}


variable "upload_file_key" {
  description = "The key of the file in the S3 bucket"
  type        = string
  default     = "images/my_image.jpg" #ชื่อไฟล์ที่จะไปแสดงบน aws
}
