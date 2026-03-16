#!/bin/bash
set -e

PLATFORM=$1
ARTIFACT=$2

if [[ $# -ne 2 ]]; then
    echo "usage: ./upload.sh <platform> <artifact path>"
    echo "[ERROR] Too few arguments"
    exit 1
fi

if [[ -z "$UPLOAD_TOKEN" ]]; then
  echo "[ERROR] 'UPLOAD_TOKEN' missing from environment"
  exit 1
fi

if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" ]]; then
  echo "[ERROR] Invalid platform: '${PLATFORM}'"
  exit 1
fi

if [[ -f $ARTIFACT ]]; then
  echo "Uploading artifact for platform: $PLATFORM"
  echo "Artifact: $ARTIFACT"
  
  # Simulate upload
  sleep 0.5
  
  echo "Upload successful"
else
  echo "[ERROR] Artifact does not exist: No such file '${ARTIFACT}'"
  exit 1
fi