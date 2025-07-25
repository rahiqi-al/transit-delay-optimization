terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 0.90"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
  }
  required_version = ">= 1.5.0"
}