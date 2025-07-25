minio : http://localhost:9001/browser
spark : http://localhost:8081/
airflow : http://localhost:8080
kafka :"""create topic:
        docker exec kafka kafka-topics --create --topic test-topic --bootstrap-server kafka:9092 --partitions 1 --replication-factor 1
        producer:
        docker exec -it kafka kafka-console-producer --topic test-topic --bootstrap-server kafka:9092
        consumer:
        docker exec -it kafka kafka-console-consumer --topic test-topic --bootstrap-server kafka:9092 --from-beginning"""

Neo4j : http://localhost:7474
databricks : pip install databricks-cli  --> databricks configure --token  --> databricks clusters list



"""
docker exec -it --user root spark-master bash
/opt/bitnami/python/bin/pip3 install python-dotenv
/opt/bitnami/python/bin/pip3 install PyYAML
docker exec -it --user root spark-worker-1 bash
/opt/bitnami/python/bin/pip3 install python-dotenv
/opt/bitnami/python/bin/pip3 install PyYAML
docker exec -it --user root spark-worker-2 bash
/opt/bitnami/python/bin/pip3 install python-dotenv
/opt/bitnami/python/bin/pip3 install PyYAML
"""