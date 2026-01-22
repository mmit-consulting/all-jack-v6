variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket in the current (bucket-owner) account."
}

# variable "principal_account_id" {
#   type        = string
#   description = "AWS account ID where the principal IAM role lives (e.g., nonprod account)."
# }

# variable "principal_role_name" {
#   type        = string
#   description = "Name of the IAM role in the other account that should access this bucket."
# }

variable "principals" {
  description = "List of IAM roles (possibly across multiple accounts) that should access this bucket."
  type = list(object({
    account_id = string
    role_name  = string
    # If you ever need paths later, switch to role_arn directly.
  }))
}

variable "access" {
  type        = string
  description = "Access level to grant: 'read' or 'readwrite'. Default: 'read'."
  default     = "read"
  validation {
    condition     = contains(["read", "readwrite"], var.access)
    error_message = "access must be 'read' or 'readwrite'."
  }
}

variable "prefixes" {
  type        = list(string)
  description = "Optional list of allowed prefixes (e.g. ['libs/','config/']). Empty = allow all objects."
  default     = []
}

variable "allow_list" {
  type        = bool
  description = "Whether to allow s3:ListBucket. Default true (most workloads need it)."
  default     = true
}
