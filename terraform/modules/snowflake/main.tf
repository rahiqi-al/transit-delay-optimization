terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 0.90"
    }
  }
}

resource "snowflake_database" "transit_db" {
  name = "TRANSIT_DELAY_OPTIMIZATION"
}

resource "snowflake_schema" "gold" {
  database = snowflake_database.transit_db.name
  name     = "GOLD"
}

resource "snowflake_table" "delay_trends" {
  database = snowflake_database.transit_db.name
  schema   = snowflake_schema.gold.name
  name     = "DELAY_TRENDS"
  column {
    name = "route_id"
    type = "STRING"
  }
  column {
    name = "timestamp"
    type = "TIMESTAMP_NTZ"
  }
  column {
    name = "predicted_delay"
    type = "FLOAT"
  }
}

resource "snowflake_table" "route_metrics" {
  database = snowflake_database.transit_db.name
  schema   = snowflake_schema.gold.name
  name     = "ROUTE_METRICS"
  column {
    name = "route_id"
    type = "STRING"
  }
  column {
    name = "avg_delay"
    type = "FLOAT"
  }
  column {
    name = "date"
    type = "DATE"
  }
}

resource "snowflake_account_role" "transit_role" {
  name = "TRANSIT_ROLE"
}

resource "snowflake_grant_privileges_to_account_role" "transit_db_grant" {
  account_role_name = snowflake_account_role.transit_role.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.transit_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "gold_schema_grant" {
  account_role_name = snowflake_account_role.transit_role.name
  privileges        = ["USAGE"]
  on_schema {
    schema_name = "${snowflake_database.transit_db.name}.${snowflake_schema.gold.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "delay_trends_grant" {
  account_role_name = snowflake_account_role.transit_role.name
  privileges        = ["SELECT"]
  on_schema_object {
    object_type = "TABLE"
    object_name = "${snowflake_database.transit_db.name}.${snowflake_schema.gold.name}.${snowflake_table.delay_trends.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "route_metrics_grant" {
  account_role_name = snowflake_account_role.transit_role.name
  privileges        = ["SELECT"]
  on_schema_object {
    object_type = "TABLE"
    object_name = "${snowflake_database.transit_db.name}.${snowflake_schema.gold.name}.${snowflake_table.route_metrics.name}"
  }
}

resource "snowflake_warehouse" "transit_warehouse" {
  name           = "TRANSIT_WAREHOUSE"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
}