#!/usr/bin/env bash

# Get GPU utilization percentage
gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# Check if the command succeeded
if [ $? -ne 0 ]; then
  echo "Error: nvidia-smi failed"
  exit 1
fi

# Output the utilization percentage (truncate to nearest integer)
echo "${gpu_utilization}%"
