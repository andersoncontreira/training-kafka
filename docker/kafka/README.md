# Kafka Docker Setup

Kafka 4.x container configuration with KRaft mode (no ZooKeeper).

## Quick Start

### Using Docker Compose (Recommended)

From the project root:

```bash
docker-compose up -d
```

This will:
- Build the Kafka image
- Start Kafka in KRaft mode
- Expose port `9092` (broker) and `9093` (controller)
- Create a persistent volume for logs

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

- **Default**: Java 21 (LTS, supported until 2028) — **recommended**
- **Compatible**: Java 17+ (LTS, supported until 2026)
- **Kafka 4.3.1**: Works with both versions
- **Base Image**: Eclipse Temurin (maintained by Adoptium)

Available Temurin tags:
- `21-jdk` (full JDK, Ubuntu-based) — default
- `21-jre` (JRE only, smaller)
- `21-jdk-alpine` (Alpine Linux, minimal)
- `21-jdk-jammy` (Ubuntu 22.04)
- `17-jdk`, `17-jre`, etc.

To use Java 17 (if needed), customize via docker-compose:

```yaml
  kafka:
    build:
      args:
        JAVA_VERSION: 17
```

Or for Alpine (smaller image):

```yaml
  kafka:
    build:
      context: ./docker/kafka
      dockerfile: Dockerfile
      args:
        JAVA_VERSION: 21-alpine
```

## Configuration

The `server.properties` file includes:
- **KRaft mode**: controller.quorum.voters configuration
- **Listeners**: PLAINTEXT (9092) and CONTROLLER (9093)
- **Data path**: `/var/kafka-logs` (mounted as volume)
- **Replication factor**: 1 (suitable for single broker)

## Testing

Test if Kafka is running:

```bash
docker exec kafka kafka-broker-api-versions.sh --bootstrap-server localhost:9092
```

Create a topic:

```bash
docker exec kafka kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --partitions 1 \
  --replication-factor 1
```

List topics:

```bash
docker exec kafka kafka-topics.sh --list \
  --bootstrap-server localhost:9092
```

## Network

- **Container hostname**: `kafka`
- **Exposed port**: `9092` (outside the container)
- **Internal port**: `9092` (for Docker network)

If running other services in Docker on the same network, connect to: `kafka:9092`
