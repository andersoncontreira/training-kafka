#!/usr/bin/env bash
# install-kafka.sh
# Downloads and extracts Apache Kafka to ~/kafka.
# Usage: bash scripts/setup/install-kafka.sh

set -euo pipefail

KAFKA_VERSION="3.7.0"
SCALA_VERSION="2.13"
KAFKA_ARCHIVE="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
KAFKA_URL="https://downloads.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_ARCHIVE}"
INSTALL_DIR="${HOME}/kafka"

echo "==> Downloading Kafka ${KAFKA_VERSION} ..."
wget -q --show-progress -O "/tmp/${KAFKA_ARCHIVE}" "${KAFKA_URL}"

echo "==> Extracting to ${INSTALL_DIR} ..."
mkdir -p "${INSTALL_DIR}"
tar -xzf "/tmp/${KAFKA_ARCHIVE}" -C "${INSTALL_DIR}" --strip-components=1

echo "==> Cleaning up ..."
rm -f "/tmp/${KAFKA_ARCHIVE}"

echo ""
echo "Kafka ${KAFKA_VERSION} installed at: ${INSTALL_DIR}"
echo ""
echo "Next steps:"
echo "  source scripts/setup/env.sh   # load KAFKA_HOME into your shell"
echo "  bash scripts/kafka/start-kafka.sh"
