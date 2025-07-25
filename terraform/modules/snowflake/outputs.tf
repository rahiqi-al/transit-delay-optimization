output "database_name" {
  description = "Name of the Snowflake database"
  value       = snowflake_database.transit_db.name
}

output "warehouse_name" {
  description = "Name of the Snowflake warehouse"
  value       = snowflake_warehouse.transit_warehouse.name
}