from confluent_kafka import Consumer, KafkaException
from minio import Minio
from minio.error import S3Error
import json
import base64
import logging
import time
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from google.transit import gtfs_realtime_pb2
from io import BytesIO

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def setup_minio():
    try:
        minio_client = Minio(
            "localhost:9000",
            access_key="ali",
            secret_key="aliali123",
            secure=False
        )
        bucket_name = "transit-data"
        logger.info(f"Checking the status of bucket {bucket_name}")
        if not minio_client.bucket_exists(bucket_name):
            minio_client.make_bucket(bucket_name)
            logger.info(f"Created bucket {bucket_name}")
        else:
            logger.info(f"Bucket {bucket_name} exists")
        return minio_client, bucket_name
    except S3Error as e:
        logger.error(f"MinIO connection error: {e}")
        raise
    except Exception as e:
        logger.error(f"Unexpected error in MinIO setup: {e}")
        raise

def parse_gtfs_data(gtfs_base64):
    try:
        gtfs_data = base64.b64decode(gtfs_base64)
        feed = gtfs_realtime_pb2.FeedMessage()
        feed.ParseFromString(gtfs_data)
        vehicles = []
        for entity in feed.entity:
            if entity.HasField('vehicle'):
                vehicle = entity.vehicle
                vehicles.append({
                    'vehicle_id': vehicle.vehicle.id,
                    'latitude': vehicle.position.latitude,
                    'longitude': vehicle.position.longitude,
                    'timestamp': vehicle.timestamp
                })
        return vehicles
    except Exception as e:
        logger.error(f"GTFS parsing error: {e}")
        return []

def save_to_minio(minio_client, bucket_name, data, timestamp):
    try:
        df = pd.DataFrame(data)
        if df.empty:
            logger.warning("No data to save")
            return
        table = pa.Table.from_pandas(df)
        file_name = f"transit_{timestamp}.parquet"
        buffer = BytesIO()
        pq.write_table(table, buffer)
        buffer.seek(0)
        minio_client.put_object(
            bucket_name,
            file_name,
            buffer,
            length=buffer.getbuffer().nbytes,
            content_type="application/octet-stream"
        )
        logger.info(f"Saved {file_name} to MinIO bucket {bucket_name}")
    except S3Error as e:
        logger.error(f"MinIO save error: {e}")
    except Exception as e:
        logger.error(f"Error saving to Parquet: {e}")

def consumer():
    consumer = Consumer({
        'bootstrap.servers': 'localhost:9092',
        'group.id': 'transit-consumer',
        'auto.offset.reset': 'earliest'
    })
    consumer.subscribe(['transit-topic'])
    try:
        minio_client, bucket_name = setup_minio()
    except Exception as e:
        logger.error("Failed to initialize MinIO. Exiting.")
        return

    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                logger.error(f"Consumer error: {msg.error()}")
                continue
            try:
                data = json.loads(msg.value().decode('utf-8'))
                gtfs_data = parse_gtfs_data(data['gtfs_raw'])
                for vehicle in gtfs_data:
                    vehicle.update({
                        'kafka_timestamp': data['timestamp'],
                        'weather': data['weather'],
                        'temperature': data['temperature'],
                        'humidity': data['humidity'],
                        'wind_speed': data['wind_speed'],
                        'rain': data['rain']
                    })
                if gtfs_data:
                    save_to_minio(minio_client, bucket_name, gtfs_data, data['timestamp'])
            except json.JSONDecodeError as e:
                logger.error(f"JSON decode error: {e}")
            except Exception as e:
                logger.error(f"Processing error: {e}")
    except KeyboardInterrupt:
        logger.info("Consumer stopped")
    finally:
        consumer.close()

if __name__ == "__main__":
    consumer()