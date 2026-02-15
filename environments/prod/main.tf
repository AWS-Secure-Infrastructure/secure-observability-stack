module "kms" {
  source = "../../modules/kms"

  name = "${var.project_name}-kms"

  tags = var.tags
}

module "logging_bucket" {
  source = "../../modules/logging_bucket"

  bucket_name = "${var.project_name}-logs-${data.aws_caller_identity.current.account_id}"
  kms_key_arn = module.kms.key_arn

  tags = var.tags
}

data "aws_caller_identity" "current" {}

module "cloudwatch_alerts" {
  source = "../../modules/cloudwatch_alerts"

  name           = var.project_name
  log_group_name = "/aws/cloudtrail/${var.project_name}"
  alarm_email    = var.alarm_email

  tags = var.tags
}

module "cloudtrail" {
  source = "../../modules/cloudtrail"

  name           = "${var.project_name}-trail"
  s3_bucket_name = module.logging_bucket.bucket_id
  kms_key_arn    = module.kms.key_arn

  cloudwatch_log_group_arn = module.cloudwatch_alerts.log_group_arn

  tags = var.tags
}

module "config" {
  source = "../../modules/config"

  name           = var.project_name
  s3_bucket_name = module.logging_bucket.bucket_id

  tags = var.tags
}

module "guardduty" {
  source = "../../modules/guardduty"

  tags = var.tags
}

module "athena" {
  source = "../../modules/athena"

  name                  = var.project_name
  s3_bucket_name        = module.logging_bucket.bucket_id
  athena_results_bucket = module.logging_bucket.bucket_id

  tags = var.tags
}

