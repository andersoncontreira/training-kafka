#!/usr/bin/env bash
# kafka-list-topics.sh
# Lists all topics on the local Kafka broker.
# Usage: bash scripts/kafka/kafka-list-topics.sh

set -euo pipefail

KAFKA_HOME="${KAFKA_HOME:-${HOME}/kafka}"
BOOTSTRAP_SERVER="${BOOTSTRAP_SERVER:-localhost:9092}"

if [[ ! -d "${KAFKA_HOME}" ]]; then
  echo "ERROR: Kafka not found at ${KAFKA_HOME}"
  echo "Run: bash scripts/kafka/kafka-install.sh"
  exit 1
fi

echo "==> Listing topics on ${BOOTSTRAP_SERVER} ..."
"${KAFKA_HOME}/bin/kafka-topics.sh" \
  --bootstrap-server "${BOOTSTRAP_SERVER}" \
  --list
