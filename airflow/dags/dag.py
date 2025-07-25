import logging
from airflow import DAG
from datetime import datetime , timedelta

###################################  use the new syntax thats similiar to prefect ###########################################


logging.basicConfig(level=logging.DEBUG,format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',filename="/opt/airflow/logs/app.log",filemode='a')
logger=logging.getLogger(__name__)

args={ 
    'owner': 'ali rahiqi',
    'depends_on_past': False,
    'retries': 3,
    'execution_timeout': timedelta(hours=1),
    'retry_delay': timedelta(minutes=3)}


def on_failure_callback(context):
    task_instance = context['task_instance']
    logger.error(f"Task {task_instance.task_id} failed. DAG: {task_instance.dag_id} at {datetime.now()}")



# with DAG('disasters', default_args=args, start_date=datetime(2025,1,1), schedule_interval='@yearly', catchup=False ,on_failure_callback=on_failure_callback) as dag :
#     check_kaggle_api = PythonSensor(task_id='check_kaggle_api', python_callable=check_kaggle_api, poke_interval=60, timeout=600)
#     #ingestion_tasks = [PythonOperator(task_id=f"ingest--{dataset.replace('/', '-')}", python_callable=ingestion, op_kwargs={"dataset": dataset}) for dataset in config.datasets ]
#     #spark_task = BashOperator(task_id='spark_test_task',bash_command='docker exec spark-master spark-submit --master spark://spark-master:7077 --packages org.apache.hadoop:hadoop-aws:3.3.4,org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.5.0,org.projectnessie.nessie-integrations:nessie-spark-extensions-3.5_2.12:0.74.0  /project/batch/scripts/test.py')
#     ingestion_tasks = {
#         f"ingest--{dataset.replace('/', '-')}": PythonOperator(
#             task_id=f"ingest--{dataset.replace('/', '-')}",
#             python_callable=ingestion,
#             op_kwargs={"dataset": dataset}
#         ) for dataset in config.datasets
#     }



#     check_mlflow_bucket = S3KeySensor(task_id='check_mlflow_bucket',bucket_key='*',bucket_name='mlflow', aws_conn_id='minio_conn',wildcard_match=True,poke_interval=30,timeout=300,)

 




    