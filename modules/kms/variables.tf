variable "name" {
  description = "Name of the KMS key"
  type        = string
}

variable "description" {
  description = "KMS key description"
  type        = string
  default     = "KMS key for AWS governance and logging"
}

variable "tags" {
  description = "Tags to apply to the KMS key"
  type        = map(string)
}
