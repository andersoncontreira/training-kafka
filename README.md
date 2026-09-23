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

- Java 17+ (managed via SDKman — see `.sdkmanrc`)
- Apache Maven 3.9+ (managed via SDKman)
- Docker + Docker Compose (for Options A and B)
- Apache Kafka 4.x locally (for Option C — see `scripts/kafka/kafka-install.sh`)

## Getting Started

### 1. Install Kafka

Download Kafka from the [official site](https://kafka.apache.org/downloads) and extract it.
The scripts in `scripts/setup/` can help with the local environment.

### 2. Start Kafka (KRaft mode — no ZooKeeper)

#### Option A — Confluent image (default, recommended)

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

#### Option B — Custom Dockerfile build

```bash
# First run (build image and start)
docker-compose -f docker-compose.custom.yml up --build -d

# Subsequent runs
docker-compose -f docker-compose.custom.yml up -d

# Stop
docker-compose -f docker-compose.custom.yml down

# Stop and remove volumes (clean slate)
docker-compose -f docker-compose.custom.yml down -v
```

Both options expose Kafka on the same addresses:
- **External (host):** `localhost:29092`
- **Internal (Docker network):** `kafka:9092`

#### Option C — Run locally without Docker

Requires Kafka installed via `bash scripts/kafka/kafka-install.sh`.

```bash
# Using the helper scripts
bash scripts/kafka/kafka-start.sh   # starts the broker
bash scripts/kafka/kafka-stop.sh    # stops the broker
```

**Or with native Kafka commands:**

```bash
# Format storage (first run only — --standalone required for single-node)
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
