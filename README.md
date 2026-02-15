# AWS Governance & Observability Stack (Terraform)

## Overview

This repository implements a modular, production-oriented AWS governance and observability foundation using Terraform.

It provisions a secure, encrypted, and centralized logging architecture integrating:

- CloudTrail (multi-region audit logging)
- AWS Config (configuration governance)
- GuardDuty (threat detection)
- CloudWatch (metric-based alerting)
- Athena + Glue (log analytics)
- KMS-encrypted S3 storage with lifecycle management

The stack is designed to reflect real-world cloud security and platform engineering practices rather than lab-style experimentation.

---

## Architecture

The stack follows a layered governance model:

### Audit Layer
- Multi-region CloudTrail
- Log file validation enabled
- Encrypted log delivery to S3

### Storage & Retention Layer
- Dedicated S3 logging bucket
- SSE-KMS encryption
- Versioning enabled
- Public access blocked
- Lifecycle policy (Glacier transition + expiration)

### Governance Layer
- AWS Config configuration recorder
- Managed compliance rule (e.g. root MFA enforcement)

### Detection Layer
- GuardDuty detector enabled
- S3 data event monitoring

### Alerting Layer
- CloudWatch Log Group with defined retention
- Metric filter for security-sensitive events
- SNS-based alerting
- Root login without MFA alarm

### Analytics Layer
- Athena Workgroup with enforced configuration
- Glue Data Catalog integration
- External table for CloudTrail querying

---

## Design Principles

- Modular Terraform architecture
- Clear separation between reusable modules and environment wiring
- KMS encryption enforced across storage components
- No hardcoded ARNs or account IDs
- Centralized tagging strategy
- Cost-aware log lifecycle management
- Explicit IAM role boundaries

---

## Repository Structure

```
modules/
├── kms/
├── logging_bucket/
├── cloudtrail/
├── config/
├── guardduty/
├── cloudwatch_alerts/
└── athena/
environments/
└── prod/
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf
```

Modules remain reusable and environment-agnostic.  
The `prod` environment wires all components together into a deployable stack.

---

## Security Hardening Highlights

- KMS key rotation enabled
- Explicit S3 bucket policy allowing only the CloudTrail service principal
- S3 public access block enforced
- Log lifecycle policy (90 days → Glacier, 365-day expiration)
- CloudTrail log file validation enabled
- Dedicated IAM role for CloudTrail → CloudWatch integration
- SNS-based alerting for critical security events
- No wildcard permissions in custom IAM policies

---

## Deployment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

---

## What This Demonstrates

This project reflects production-focused cloud engineering capabilities:
- Governance architecture design
- Detection engineering integration
- Secure logging pipeline implementation
- Infrastructure modularization
- IAM boundary awareness
- Operational cost considerations
- Platform-level observability design

It is structured to align with responsibilities typical of Cloud Engineer, Platform Engineer, or Junior SRE roles.

---

## Potential Extensions

- Organization-wide CloudTrail and GuardDuty integration
- Object Lock for compliance-grade immutability
- Additional AWS Config managed or custom rules
- Athena partition optimization for performance
- Slack or PagerDuty alert integration
- Multi-account governance expansion

---

## Author

Sebastian Silva C. - Cloud Engineer – Secure Infrastructure & Automation - Berlin, Germany
