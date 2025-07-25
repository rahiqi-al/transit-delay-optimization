output "databricks_job_ids" {
  description = "IDs of the Databricks jobs"
  value = {
    ingest_kafka   = databricks_job.ingest_kafka.id
    process_bronze = databricks_job.process_bronze.id
    process_silver = databricks_job.process_silver.id
    process_gold   = databricks_job.process_gold.id
    neo4j_update   = databricks_job.neo4j_update.id
  }
}