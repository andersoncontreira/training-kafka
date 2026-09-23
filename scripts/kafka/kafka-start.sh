#!/usr/bin/env bash
# kafka-start.sh
# Starts a local Kafka broker in KRaft mode (Kafka 4.x — no ZooKeeper).
#
# Usage:
#   bash scripts/kafka/kafka-start.sh           # normal start
#   bash scripts/kafka/kafka-start.sh --reset   # wipe storage and reformat before starting

set -euo pipefail

KAFKA_HOME="${KAFKA_HOME:-${HOME}/kafka}"
KRAFT_CONFIG="${KAFKA_HOME}/config/server.properties"
STORAGE_DIR="/tmp/kraft-combined-logs"
FLAG_FILE="${HOME}/.kafka-kraft-formatted"
RESET=false

# Parse flags
for arg in "$@"; do
  case "${arg}" in
    --reset)
      RESET=true
      ;;
    *)
      echo "Unknown flag: ${arg}"
      echo "Usage: bash scripts/kafka/kafka-start.sh [--reset]"
      exit 1
      ;;
  esac
done

if [[ ! -d "${KAFKA_HOME}" ]]; then
  echo "ERROR: Kafka not found at ${KAFKA_HOME}"
  echo "Run: bash scripts/kafka/kafka-install.sh"
  exit 1
fi

# --reset: wipe existing storage and flag so it gets reformatted
if [[ "${RESET}" == "true" ]]; then
  echo "==> Resetting KRaft storage ..."
  rm -rf "${STORAGE_DIR}"
  rm -f "${FLAG_FILE}"
  echo "==> Storage cleared."
fi

# Format storage on first run (or after reset)
# Check both the flag file AND the actual storage directory
if [[ ! -f "${FLAG_FILE}" && ! -d "${STORAGE_DIR}" ]]; then
  echo "==> Formatting KRaft storage ..."
  KAFKA_CLUSTER_ID="$("${KAFKA_HOME}/bin/kafka-storage.sh" random-uuid)"
  "${KAFKA_HOME}/bin/kafka-storage.sh" format \
    -t "${KAFKA_CLUSTER_ID}" \
    -c "${KRAFT_CONFIG}" \
    --standalone
  touch "${FLAG_FILE}"
  echo "==> Storage formatted."
else
  echo "==> Storage already exists, skipping format step."
  echo "    Use --reset to wipe and reformat."
fi

echo ""
echo "==> Starting Kafka broker (KRaft mode) ..."
echo "    Config : ${KRAFT_CONFIG}"
echo "    Press Ctrl+C to stop."
echo ""
"${KAFKA_HOME}/bin/kafka-server-start.sh" "${KRAFT_CONFIG}"
