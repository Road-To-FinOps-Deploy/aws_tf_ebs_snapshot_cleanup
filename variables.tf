variable "function_prefix" {
  default = "tet"
}


variable "snapshot_cleanup_cron" {
  description = "interval of time to trigger lambda function"
  default     = "cron(0 0 ? * * *)"
}