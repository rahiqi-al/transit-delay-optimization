terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
  }
}

data "databricks_cluster" "existing_cluster" {
  cluster_name = "Serverless Starter Warehouse"
}

resource "databricks_notebook" "exploratory_analysis" {
  source = "${path.module}/../../../databricks/notebooks/exploratory_analysis.ipynb"
  path   = "${var.databricks_scripts_dir}/exploratory_analysis.ipynb"
}

resource "databricks_notebook" "model_validation" {
  source = "${path.module}/../../../databricks/notebooks/model_validation.ipynb"
  path   = "${var.databricks_scripts_dir}/model_validation.ipynb"
}

resource "databricks_notebook" "ingest_kafka" {
  source = "${path.module}/../../../databricks/scripts/ingest_kafka.py"
  path   = "${var.databricks_scripts_dir}/ingest_kafka.py"
}

resource "databricks_notebook" "process_bronze" {
  source = "${path.module}/../../../databricks/scripts/process_bronze.py"
  path   = "${var.databricks_scripts_dir}/process_bronze.py"
}

resource "databricks_notebook" "process_silver" {
  source = "${path.module}/../../../databricks/scripts/process_silver.py"
  path   = "${var.databricks_scripts_dir}/process_silver.py"
}

resource "databricks_notebook" "process_gold" {
  source = "${path.module}/../../../databricks/scripts/process_gold.py"
  path   = "${var.databricks_scripts_dir}/process_gold.py"
}

resource "databricks_notebook" "neo4j_update" {
  source = "${path.module}/../../../databricks/scripts/neo4j_update.py"
  path   = "${var.databricks_scripts_dir}/neo4j_update.py"
}

resource "databricks_job" "ingest_kafka" {
  name               = "ingest_kafka_job"
  existing_cluster_id = data.databricks_cluster.existing_cluster.id
  notebook_task {
    notebook_path = "${var.databricks_scripts_dir}/ingest_kafka.py"
  }
}

resource "databricks_job" "process_bronze" {
  name               = "process_bronze_job"
  existing_cluster_id = data.databricks_cluster.existing_cluster.id
  notebook_task {
    notebook_path = "${var.databricks_scripts_dir}/process_bronze.py"
  }
}

resource "databricks_job" "process_silver" {
  name               = "process_silver_job"
  existing_cluster_id = data.databricks_cluster.existing_cluster.id
  notebook_task {
    notebook_path = "${var.databricks_scripts_dir}/process_silver.py"
  }
}

resource "databricks_job" "process_gold" {
  name               = "process_gold_job"
  existing_cluster_id = data.databricks_cluster.existing_cluster.id
  notebook_task {
    notebook_path = "${var.databricks_scripts_dir}/process_gold.py"
  }
}

resource "databricks_job" "neo4j_update" {
  name               = "neo4j_update_job"
  existing_cluster_id = data.databricks_cluster.existing_cluster.id
  notebook_task {
    notebook_path = "${var.databricks_scripts_dir}/neo4j_update.py"
  }
}