#!/bin/sh
set -eu

KAFKA_HOME="/opt/kafka"
CONFIG_FILE="${KAFKA_HOME}/config/server.properties"
DATA_DIR="/var/kafka-logs"
FORMAT_FLAG="${DATA_DIR}/.kraft-formatted"

# Create data directory if it doesn't exist
mkdir -p "${DATA_DIR}"

# Format KRaft storage on first run
if [ ! -f "${FORMAT_FLAG}" ]; then
  echo "==> Formatting KRaft storage (first run) ..."

  CLUSTER_ID="${CLUSTER_ID:-$(${KAFKA_HOME}/bin/kafka-storage.sh random-uuid)}"

  ${KAFKA_HOME}/bin/kafka-storage.sh format \
    --cluster-id "${CLUSTER_ID}" \
    --config "${CONFIG_FILE}" \
    --ignore-formatted

  touch "${FORMAT_FLAG}"
  echo "==> Storage formatted."
fi

echo "==> Starting Kafka broker (KRaft mode) ..."
echo "==> Press Ctrl+C to stop."

exec ${KAFKA_HOME}/bin/kafka-server-start.sh ${CONFIG_FILE}
