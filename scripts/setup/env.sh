#!/usr/bin/env bash
# env.sh
# Loads Kafka environment variables into the current shell.
# Usage: source scripts/setup/env.sh

export KAFKA_HOME="${HOME}/kafka"
export PATH="${KAFKA_HOME}/bin:${PATH}"

echo "Kafka environment loaded."
echo "  KAFKA_HOME=${KAFKA_HOME}"
echo "  kafka-topics.sh and other CLI tools are now in PATH."
