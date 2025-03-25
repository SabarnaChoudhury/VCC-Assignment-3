# Auto-Scaling Local VM to Google Cloud Based on Resource Usage

## 📌 Objective
Monitor CPU and memory usage in a local Lubuntu VM and auto-scale to GCP when thresholds exceed 75%.

## 📂 Project Structure

- `flask_app/`: Simple Python app running on port 5000
- `prometheus/`: Prometheus configuration (targets, scrape intervals)
- `auto_scale.sh`: Bash script to check usage and launch GCP VM
- `crontab.txt`: Cron entry for running the script every 5 minutes
- `logs/`: Sample log entries
- `screenshots/`: (Optional) Graphs and GCP instance proof

## ⚙️ Tech Stack
- Lubuntu 22.04 (inside VirtualBox)
- Prometheus + Node Exporter
- Python Flask
- Google Cloud CLI (`gcloud`)
- Bash scripting

## 📈 Monitoring Queries
- CPU: `100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)`
- Memory: `100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))`

## ☁️ GCP Command Used
```bash
gcloud compute instances create auto-scale-vm \
  --zone=asia-south1-a \
  --machine-type=e2-micro \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud
