variable "function_prefix" {
  default = "test"
}


variable "snapshot_cleanup_cron" {
  description = "interval of time to trigger lambda function"
  default     = "cron(0 0 ? * * *)"
}

variable "time_interval" {
  default     = 90
  description = "The number of days the Snapshot has been there and so will no be deleted"
}

variable "DryRun" {
  default     = false
  description = "True or false for if you want the lambda to delete the snaps"
  type  = bool 
}