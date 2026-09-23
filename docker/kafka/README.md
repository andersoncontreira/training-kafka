# Kafka Docker Setup

Kafka 4.x container configuration with KRaft mode (no ZooKeeper).

## Quick Start

### Using Docker Compose with Custom Build

From the project root:

```bash
docker-compose -f docker-compose.custom.yml up --build -d
```

This will:
- Build the custom Kafka image (from this Dockerfile)
- Start Kafka in KRaft mode
- Expose port `9092` (broker) and `9093` (controller)
- Create a persistent volume for logs

**Note**: For the default Confluent image, use `docker-compose up -d` instead.

### Check Status

```bash
docker-compose logs -f kafka
```

### Stop Kafka

```bash
docker-compose down
```

### Remove volumes (reset data)

```bash
docker-compose down -v
```

## Manual Docker Build & Run

Build the image (with Java 21):

```bash
docker build -t training-kafka:4.3.1 .
```

Or with a specific Java version:

```bash
docker build --build-arg JAVA_VERSION=17 -t training-kafka:4.3.1-java17 .
```

Run the container:

```bash
docker run -d \
  --name kafka \
  -p 9092:9092 \
  -p 9093:9093 \
  -e CLUSTER_ID="MkQkTWVlNDQ2YjUwMjQ1Mzk4" \
  -v kafka-logs:/var/kafka-logs \
  training-kafka:4.3.1
```

## Java Version Compatibility

- **Current**: Java 21 (LTS, supported until 2028) on **Alpine Linux** — lightweight & recommended
- **Compatible**: Java 17+ (LTS, supported until 2026)
- **Kafka 4.3.1**: Works with both versions
- **Base Image**: `eclipse-temurin:${JAVA_VERSION}-jdk-alpine` (maintained by Adoptium)

To use a different Java version, pass via build arg:

```bash
docker build --build-arg JAVA_VERSION=17 -t training-kafka:4.3.1-java17 .
```

Or via docker-compose:

```yaml
  kafka:
    build:
      context: ./docker/kafka
      dockerfile: Dockerfile
      args:
        JAVA_VERSION: 17  # Uses 17-jdk-alpine
```

## Configuration

### Files

- **`Dockerfile`**: Builds the image with Kafka 4.3.1 on Alpine + Java 21
- **`server.properties`**: Kafka broker configuration in KRaft mode
- **`entrypoint.sh`**: Automatically formats KRaft storage on first run

### Settings

The `server.properties` file includes:
- **KRaft mode**: `process.roles=broker,controller` and `controller.quorum.voters=1@kafka:9093`
- **Listeners**: PLAINTEXT (9092) and CONTROLLER (9093)
- **Data path**: `/var/kafka-logs` (mounted as volume)
- **Replication factor**: 1 (suitable for single-node setup)

The `entrypoint.sh` script:
- Detects first run and formats storage automatically
- Sets `CLUSTER_ID` from environment or generates one
- Starts the Kafka broker in KRaft mode

## Testing

Test if Kafka is running:

```bash
docker exec training-kafka kafka-broker-api-versions.sh --bootstrap-server localhost:9092
```

Create a topic:

```bash
docker exec training-kafka kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --partitions 1 \
  --replication-factor 1
```

List topics:

```bash
docker exec training-kafka kafka-topics.sh --list \
  --bootstrap-server localhost:9092
```

## Network

- **Container hostname**: `kafka`
- **Exposed port**: `9092` (outside the container)
- **Internal port**: `9092` (for Docker network)

If running other services in Docker on the same network, connect to: `kafka:9092`
