provider "snowflake" {
  account_name      = var.snowflake_account
  organization_name = var.snowflake_organization
  user              = var.snowflake_username
  password          = var.snowflake_password
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}