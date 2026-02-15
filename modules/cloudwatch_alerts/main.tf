resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = 90

  tags = var.tags
}

resource "aws_cloudwatch_log_metric_filter" "root_login_no_mfa" {
  name           = "${var.name}-root-login-no-mfa"
  log_group_name = aws_cloudwatch_log_group.this.name

  pattern = "{ ($.userIdentity.type = Root) && ($.eventName = ConsoleLogin) && ($.additionalEventData.MFAUsed != Yes) }"

  metric_transformation {
    name      = "RootLoginWithoutMFA"
    namespace = "Security"
    value     = "1"
  }
}

resource "aws_sns_topic" "security_alerts" {
  name = "${var.name}-security-alerts"

  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "root_login_alarm" {
  alarm_name          = "${var.name}-root-login-no-mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RootLoginWithoutMFA"
  namespace           = "Security"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.security_alerts.arn]

  tags = var.tags
}
