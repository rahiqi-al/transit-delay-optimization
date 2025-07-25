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
}