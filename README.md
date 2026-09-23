# training-kafka

A hands-on training repository for learning Apache Kafka, following the Udemy course
[Apache Kafka para Iniciantes](https://www.udemy.com/course/apache-kafka-para-iniciantes/).

## Course Coverage

- Kafka core concepts: topics, partitions, offsets, brokers
- Producers and consumers via Kafka CLI
- Java producers and consumers using the Kafka client library
- Consumer groups and rebalancing
- Kafka configurations and monitoring

## Project Structure

```
training-kafka/
├── scripts/
│   ├── kafka/          # Kafka CLI helper scripts (topics, producers, consumers)
│   └── setup/          # Environment setup scripts
├── kafka-basics/       # Java Maven project with producer/consumer exercises
│   └── src/
│       └── main/java/
│           └── com/training/kafka/
│               ├── producer/
│               └── consumer/
└── README.md
```

## Prerequisites

- Java 11+
- Apache Maven 3.6+
- Apache Kafka 3.x (see [setup guide](scripts/setup/README.md))

## Getting Started

### 1. Install Kafka

Download Kafka from the [official site](https://kafka.apache.org/downloads) and extract it.
The scripts in `scripts/setup/` can help with the local environment.

### 2. Start Kafka (KRaft mode — no ZooKeeper)

**Default — Confluent image (recommended):**
```bash
docker-compose up -d
```

**Alternative — Custom Dockerfile build:**
```bash
docker-compose -f docker-compose.custom.yml up -d
```

**Stop:**
```bash
docker-compose down
```

**Or run locally without Docker (requires Kafka installed via `kafka-install.sh`):**
```bash
bash scripts/kafka/kafka-start.sh

# Stop the broker
bash scripts/kafka/kafka-stop.sh
```

**Or use native Kafka commands:**

```bash
# Format storage (first run only)
# Note: --standalone is required for single-node local setup
~/kafka/bin/kafka-storage.sh format \
  --cluster-id "$(~/kafka/bin/kafka-storage.sh random-uuid)" \
  --config ~/kafka/config/server.properties \
  --standalone

# Start the broker
~/kafka/bin/kafka-server-start.sh ~/kafka/config/server.properties

# Stop the broker (in another terminal)
~/kafka/bin/kafka-server-stop.sh
```

### 3. Build the Java project

```bash
cd kafka-basics
mvn clean package
```

### 4. Run the examples

```bash
# Producer
mvn exec:java -Dexec.mainClass="com.training.kafka.producer.ProducerDemo"

# Consumer
mvn exec:java -Dexec.mainClass="com.training.kafka.consumer.ConsumerDemo"
```

## Scripts

Helper scripts are organized under `scripts/`:

| Folder | Purpose |
|--------|---------|
| `scripts/kafka/` | Kafka CLI scripts: `kafka-install.sh`, `kafka-start.sh`, `kafka-list-topics.sh`, and more |
| `scripts/setup/` | Environment setup (SDKman versions, environment variables) |

## Notes

- Kafka is run locally in **KRaft mode** (no ZooKeeper) as required by Kafka 4.x
- Default broker address: `localhost:29092` (external) / `kafka:9092` (internal Docker network)
- All code examples use the official Apache Kafka Java client
