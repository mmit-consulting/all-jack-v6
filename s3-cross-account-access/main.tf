module "beanstalk_config_access" {
  source = "../../modules/s3_cross_account_bucket_access"

  bucket_name = "com.hoopladigital.beanstalk.config"

  principal_account_id = var.nonprod_account_id
  principal_role_name  = "nonprod_reader_role"

  access     = "read"
  prefixes   = [] # or ["libs/"] if you can scope it
  allow_list = true
}
