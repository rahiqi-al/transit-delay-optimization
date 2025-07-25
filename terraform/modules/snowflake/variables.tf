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