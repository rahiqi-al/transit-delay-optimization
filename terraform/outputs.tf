output "snowflake_database_name" {
  description = "Name of the Snowflake database"
  value       = module.snowflake.database_name
}

output "snowflake_warehouse_name" {
  description = "Name of the Snowflake warehouse"
  value       = module.snowflake.warehouse_name
}

# output "databricks_job_ids" {
#   description = "IDs of the Databricks jobs"
#   value       = module.databricks_existing_cluster.databricks_job_ids
# }