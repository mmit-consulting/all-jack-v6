output "principal_role_arn" {
  description = "The role ARN (in the other account) that was granted access."
  value       = "arn:aws:iam::${var.principal_account_id}:role/${var.principal_role_name}"
}

output "bucket_arn" {
  description = "ARN of the bucket where access was granted."
  value       = "arn:aws:s3:::${var.bucket_name}"
}

output "policy_json" {
  description = "Rendered bucket policy JSON applied by this module."
  value       = data.aws_iam_policy_document.cross_account_policy.json
}
