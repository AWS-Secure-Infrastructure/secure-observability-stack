resource "aws_guardduty_detector" "this" {
  enable = var.enable

  finding_publishing_frequency = "SIX_HOURS"

  tags = var.tags
}

resource "aws_guardduty_detector_feature" "s3_logs" {
  detector_id = aws_guardduty_detector.this.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}
