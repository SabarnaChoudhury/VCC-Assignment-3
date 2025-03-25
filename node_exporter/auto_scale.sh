#!/bin/bash

# Thresholds
CPU_THRESHOLD=75.0
MEM_THRESHOLD=75.0

# Get CPU usage (user + system)
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Get Memory usage
MEM_USED=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Log file
LOG_FILE="/tmp/auto_scale.log"

# Write resource usage to log
echo "$(date): CPU: $CPU_LOAD%, Memory: $MEM_USED%" >> "$LOG_FILE"

# Check if threshold exceeded
if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )) || (( $(echo "$MEM_USED > $MEM_THRESHOLD" | bc -l) )); then
    echo "$(date): Threshold exceeded, launching GCP VM..." >> "$LOG_FILE"
    
    # Launch GCP instance
    gcloud compute instances create auto-scale-vm \
      --zone=asia-south1-a \
      --machine-type=e2-micro \
      --image-family=ubuntu-2204-lts \
      --image-project=ubuntu-os-cloud \
      --quiet

    echo "$(date): GCP VM launched successfully." >> "$LOG_FILE"
else
    echo "$(date): Usage normal, no action taken." >> "$LOG_FILE"
fi
