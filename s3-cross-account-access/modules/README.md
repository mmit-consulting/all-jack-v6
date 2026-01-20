# s3_cross_account_bucket_access

Terraform module to grant cross-account access to an S3 bucket by attaching a bucket policy that allows
a role in another AWS account (e.g., nonprod) to access a bucket in the current account (e.g., prod).

This module is intended where IAM roles are created centrally (in a separate location)
and infrastructure stacks consume role ARNs/names.

---

## What it does

- Builds the principal role ARN from:
  - `principal_account_id`
  - `principal_role_name`
- Applies an `aws_s3_bucket_policy` to the bucket in the current account that:
  - (optionally) allows `s3:ListBucket` (prefix-restricted if `prefixes` provided)
  - allows `s3:GetObject` / `s3:GetObjectVersion` on objects
  - optionally allows write actions if `access = "readwrite"`
  - (optionally) denies non-TLS requests (`aws:SecureTransport = false`)

---

## Inputs

| Name                 | Type         | Default | Description                                               |
| -------------------- | ------------ | ------- | --------------------------------------------------------- |
| bucket_name          | string       | n/a     | Bucket name in current (owner) account                    |
| principal_account_id | string       | n/a     | Account ID where the role exists (e.g. nonprod)           |
| principal_role_name  | string       | n/a     | Role name in the other account                            |
| access               | string       | "read"  | "read" or "readwrite"                                     |
| prefixes             | list(string) | []      | Restrict object access to these prefixes (e.g. ["libs/"]) |
| allow_list           | bool         | true    | Allow ListBucket (often required)                         |

---

## Outputs

| Name               | Description                      |
| ------------------ | -------------------------------- |
| principal_role_arn | Role ARN that was granted access |
| bucket_arn         | Bucket ARN                       |
| policy_json        | Final bucket policy JSON         |

---

## Example usage (Hoopla Prod account)

```hcl
module "beanstalk_config_access" {
  source = "../../modules/s3_cross_account_bucket_access"

  bucket_name          = "com.hoopladigital.beanstalk.config" # hoopla prod bucket

  principal_account_id = var.nonprod_account_id
  principal_role_name  = "nonprod_reader_role" # non prod account role

  access      = "read"
  prefixes    = []       # or ["libs/"] if you can scope it
  allow_list  = true
}
```

On the hoopla non prod account, here is the minimal policies that the role should have

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListProdBucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::com.hoopladigital.beanstalk.config"
    },
    {
      "Sid": "ReadObjectsFromProdBucket",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:GetObjectVersion"],
      "Resource": "arn:aws:s3:::com.hoopladigital.beanstalk.config/*"
    }
  ]
}
```

and don't forget the trust policy
