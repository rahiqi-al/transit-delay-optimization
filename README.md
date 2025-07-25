# 🚍 Transit Delay Optimization

A **real-time public transit delay prediction** and **route optimization system** built on a robust **Kappa architecture**.

This system processes **GTFS Realtime** data, predicts delays using **machine learning**, optimizes routes via **Neo4j**, and visualizes outcomes through an interactive **Streamlit dashboard** with maps.

---

## ✨ Features

* 🔄 **Streams GTFS data** via **Kafka**, enriched with **weather** and **traffic** data
* 🪙 **Processes data** in **MinIO** (bronze/silver) and **Snowflake** (gold)
* 🧭 **Optimizes routes** using **Neo4j** with **Dijkstra’s algorithm**
* 🗺️ **Displays real-time delays** and optimized paths on a **Folium/Leaflet** map
* ⚙️ **Orchestrates tasks** using **Airflow**
* 🚀 **Deploys infrastructure** with **Terraform** and **GitHub Actions**
