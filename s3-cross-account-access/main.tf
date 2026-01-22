module "beanstalk_config_access" {
  source = "../../modules/s3_cross_account_bucket_access"

  bucket_name = "com.hoopladigital.beanstalk.config"

  principals = [
    { account_id = "174530848851", role_name = "nonprod_s3_reader_role" },
    { account_id = "111122223333", role_name = "some_other_role" }
  ]

  access     = "read"
  prefixes   = [] # or ["libs/"] if you can scope it
  allow_list = true
}
