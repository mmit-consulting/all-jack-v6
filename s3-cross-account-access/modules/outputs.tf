output "principal_role_arns" {
  description = "List of role ARNs granted access."
  value       = local.principal_role_arns
}

output "bucket_arn" {
  description = "ARN of the bucket where access was granted."
  value       = "arn:aws:s3:::${var.bucket_name}"
}

output "policy_json" {
  description = "Rendered bucket policy JSON applied by this module."
  value       = data.aws_iam_policy_document.cross_account_policy.json
}
