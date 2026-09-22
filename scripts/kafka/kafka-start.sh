#!/usr/bin/env bash
# kafka-start.sh
# Starts a local Kafka broker in KRaft mode (no ZooKeeper).
# On first run, formats the storage directory automatically.
# Usage: bash scripts/kafka/kafka-start.sh

set -euo pipefail

KAFKA_HOME="${KAFKA_HOME:-${HOME}/kafka}"
KRAFT_CONFIG="${KAFKA_HOME}/config/kraft/server.properties"
STORAGE_DIR="/tmp/kraft-combined-logs"

if [[ ! -d "${KAFKA_HOME}" ]]; then
  echo "ERROR: Kafka not found at ${KAFKA_HOME}"
  echo "Run: bash scripts/kafka/kafka-install.sh"
  exit 1
fi

# Format storage on first run (flag file used to avoid re-formatting)
FLAG_FILE="${STORAGE_DIR}/.formatted"
if [[ ! -f "${FLAG_FILE}" ]]; then
  echo "==> Formatting KRaft storage directory ..."
  KAFKA_CLUSTER_ID="$("${KAFKA_HOME}/bin/kafka-storage.sh" random-uuid)"
  "${KAFKA_HOME}/bin/kafka-storage.sh" format \
    -t "${KAFKA_CLUSTER_ID}" \
    -c "${KRAFT_CONFIG}"
  mkdir -p "${STORAGE_DIR}"
  touch "${FLAG_FILE}"
fi

echo "==> Starting Kafka broker (KRaft mode) ..."
echo "    Config : ${KRAFT_CONFIG}"
echo "    Press Ctrl+C to stop."
echo ""
"${KAFKA_HOME}/bin/kafka-server-start.sh" "${KRAFT_CONFIG}"
