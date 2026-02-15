variable "name" {
  description = "Name prefix for AWS Config resources"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket for AWS Config delivery channel"
  type        = string
}

variable "tags" {
  description = "Tags to apply to AWS Config resources"
  type        = map(string)
}
