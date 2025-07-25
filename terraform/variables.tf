variable "snowflake_account" {
  description = "Snowflake account name"
  type        = string
  sensitive   = true
}

variable "snowflake_organization" {
  description = "Snowflake organization name"
  type        = string
  sensitive   = true
}

variable "snowflake_username" {
  description = "Snowflake username"
  type        = string
  sensitive   = true
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
  sensitive   = true
}

variable "snowflake_region" {
  description = "Snowflake region"
  type        = string
  default     = null
}

variable "databricks_host" {
  description = "Databricks workspace host URL"
  type        = string
  sensitive   = true
}

variable "databricks_token" {
  description = "Databricks personal access token"
  type        = string
  sensitive   = true
}

variable "databricks_scripts_dir" {
  description = "Directory path for Databricks scripts"
  type        = string
  default     = "/Workspace/scripts"
}