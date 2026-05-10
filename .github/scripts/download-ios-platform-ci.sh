#!/usr/bin/env bash
set -euo pipefail


max_attempts="${DOWNLOAD_IOS_MAX_ATTEMPTS:-5}"
attempt=1

while [[ "$attempt" -le "$max_attempts" ]]; do
  if xcodebuild -downloadPlatform iOS; then
    echo "downloadPlatform iOS succeeded"
    exit 0
  fi
  echo "downloadPlatform failed (${attempt}/${max_attempts}), retry in 45s..." >&2
  sleep 45
  attempt=$((attempt + 1))
done

echo "error: xcodebuild -downloadPlatform iOS failed after ${max_attempts} attempts" >&2
exit 1
