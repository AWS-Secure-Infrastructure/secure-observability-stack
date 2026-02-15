variable "enable" {
  description = "Enable GuardDuty detector"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for GuardDuty resources"
  type        = map(string)
}
