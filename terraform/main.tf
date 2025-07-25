module "snowflake" {
  source = "./modules/snowflake"

  snowflake_account       = var.snowflake_account
  snowflake_organization  = var.snowflake_organization
  snowflake_username      = var.snowflake_username
  snowflake_password      = var.snowflake_password
  snowflake_region        = var.snowflake_region

  providers = {
    snowflake = snowflake
  }
}

# module "databricks_existing_cluster" {
#   source = "./modules/databricks_existing_cluster"

#   databricks_host        = var.databricks_host
#   databricks_token       = var.databricks_token
#   databricks_scripts_dir = var.databricks_scripts_dir

#   providers = {
#     databricks = databricks
#   }
# }