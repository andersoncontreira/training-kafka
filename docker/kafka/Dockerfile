ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine

ARG KAFKA_VERSION=4.3.1
ARG SCALA_VERSION=2.13

ENV KAFKA_HOME=/opt/kafka \
    KAFKA_VERSION=${KAFKA_VERSION}

# bash is required because kafka-*.sh scripts use #!/bin/bash
RUN apk add --no-cache wget tar gzip bash

WORKDIR /opt

RUN echo "Downloading Kafka ${KAFKA_VERSION}..." && \
    wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
    echo "Extracting..." && \
    tar -xzf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
    mv "kafka_${SCALA_VERSION}-${KAFKA_VERSION}" kafka && \
    rm "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
    mkdir -p /var/kafka-logs && \
    echo "Kafka installed at:" && ls /opt/kafka/bin/kafka-storage.sh

WORKDIR ${KAFKA_HOME}

EXPOSE 9092 9093

COPY server.properties config/server.properties
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
