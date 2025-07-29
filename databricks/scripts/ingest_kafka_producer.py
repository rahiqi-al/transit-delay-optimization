from confluent_kafka import Producer
from confluent_kafka.admin import AdminClient, NewTopic
import json
import time
import logging
import requests
import base64
import urllib.parse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def report(err, msg):
    if err:
        logger.error(f'Message failed: {err}')
    else:
        logger.info(f'Message sent to {msg.topic()}')

def fetch_weather_api():
    url = 'https://api.openweathermap.org/data/2.5/weather'
    params = {
        'q': 'San Francisco,CA,US',
        'appid': 'dcf7fb8a0570efe1e58ba52fcb1d31e3',
        'units': 'metric'
    }
    for attempt in range(3):
        try:
            response = requests.get(url, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()
            return {
                'temperature': data['main']['temp'],
                'humidity': data['main']['humidity'],
                'wind_speed': data['wind']['speed'] * 3.6,
                'rain': data.get('rain', {}).get('1h', 0.0)
            }
        except requests.exceptions.RequestException as e:
            logger.error(f'Weather fetch failed on attempt {attempt+1}: {e}')
            if attempt < 2:
                logger.info('Retrying after 30 seconds')
                time.sleep(30)
            else:
                logger.error('All retries failed')
                raise

def fetch_gtfs_data():
    url = 'https://api.511.org/transit/vehiclepositions'
    params = {'api_key': '3f5a70f4-d9c3-4c14-af1f-1c0e04452944', 'agency': 'SF'}
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'}
    for attempt in range(3):
        try:
            response = requests.get(url, params=params, headers=headers, timeout=10, verify=False)
            response.raise_for_status()
            return base64.b64encode(response.content).decode('utf-8')
        except requests.exceptions.RequestException as e:
            logger.error(f'GTFS fetch failed on attempt {attempt+1}: {e}')
            if attempt < 2:
                logger.info('Retrying after 30 seconds')
                time.sleep(30)
            else:
                logger.error('All retries failed')
                raise

def producer():
    admin = AdminClient({'bootstrap.servers': 'localhost:9092'})
    topic = 'transit-topic'
    if topic not in admin.list_topics().topics:
        admin.create_topics([NewTopic(topic, num_partitions=1, replication_factor=1)])
        logger.info(f'Created {topic}')
    else:
        logger.info(f'{topic} exists')

    producer = Producer({'bootstrap.servers': 'localhost:9092'})
    while True:
        try:
            gtfs_data = fetch_gtfs_data()
            weather_data = fetch_weather_api()
            data = {
                'gtfs_raw': gtfs_data,
                'timestamp': int(time.time()),
                'weather': weather_data.get('weather', [{}])[0].get('description', ''),
                'temperature': weather_data.get('temperature', 0),
                'humidity': weather_data.get('humidity', 0),
                'wind_speed': weather_data.get('wind_speed', 0),
                'rain': weather_data.get('rain', 0)
            }
            producer.produce(topic=topic, value=json.dumps(data), callback=report)
            producer.flush()
            logger.info('Data sent to Kafka')
            time.sleep(60)
        except Exception as e:
            logger.error(f'Producer error: {e}')
            time.sleep(60)

if __name__ == "__main__":
    producer()