#!/usr/bin/env bash
# kafka-stop.sh
# Gracefully stops the local Kafka broker.
# Usage: bash scripts/kafka/kafka-stop.sh

set -euo pipefail

KAFKA_HOME="${KAFKA_HOME:-${HOME}/kafka}"

if [[ ! -d "${KAFKA_HOME}" ]]; then
  echo "ERROR: Kafka not found at ${KAFKA_HOME}"
  exit 1
fi

echo "==> Stopping Kafka broker ..."
"${KAFKA_HOME}/bin/kafka-server-stop.sh"
echo "==> Kafka stopped."
