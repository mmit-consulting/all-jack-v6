locals {
  bucket_arn = "arn:aws:s3:::${var.bucket_name}"

  # Object ARNs: whole bucket or specific prefixes
  object_arns = length(var.prefixes) == 0 ? ["arn:aws:s3:::${var.bucket_name}/*"] : [for p in var.prefixes : "arn:aws:s3:::${var.bucket_name}/${p}*"]
  # Role in the OTHER account that we want to grant access to
  # principal_role_arn = "arn:aws:iam::${var.principal_account_id}:role/${var.principal_role_name}"

  principal_role_arns = [
    for p in var.principals :
    "arn:aws:iam::${p.account_id}:role/${p.role_name}"
  ]




  # Access mode -> actions
  read_object_actions = ["s3:GetObject", "s3:GetObjectVersion"]

  write_object_actions = var.access == "readwrite" ? ["s3:PutObject", "s3:AbortMultipartUpload", "s3:DeleteObject"] : []

  # Whether to include ListBucket (some workloads can work without it if they know exact object keys)
  list_bucket_actions = var.allow_list ? ["s3:ListBucket"] : []
}

data "aws_iam_policy_document" "cross_account_policy" {
  # Allow ListBucket (optional) - can be prefix-scoped using s3:prefix condition
  dynamic "statement" {
    for_each = var.allow_list ? [1] : []
    content {
      sid    = "AllowCrossAccountListBucket"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = local.principal_role_arns
      }

      actions   = local.list_bucket_actions
      resources = [local.bucket_arn]

      dynamic "condition" {
        for_each = length(var.prefixes) == 0 ? [] : [1]
        content {
          test     = "StringLike"
          variable = "s3:prefix"
          values   = [for p in var.prefixes : "${p}*"]
        }
      }
    }
  }

  # Allow read objects
  statement {
    sid    = "AllowCrossAccountReadObjects"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.principal_role_arns
    }

    actions   = local.read_object_actions
    resources = local.object_arns
  }

  # Optional: allow write objects
  dynamic "statement" {
    for_each = var.access == "readwrite" ? [1] : []
    content {
      sid    = "AllowCrossAccountWriteObjects"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = local.principal_role_arns
      }

      actions   = local.write_object_actions
      resources = local.object_arns
    }
  }

}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.cross_account_policy.json
}
