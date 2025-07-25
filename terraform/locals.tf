locals {
  project_name = "transit_delay_optimization"
  environment  = terraform.workspace == "default" ? "dev" : terraform.workspace
}