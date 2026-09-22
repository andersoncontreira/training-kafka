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

### 2. Start Kafka (KRaft mode — no ZooKeeper needed in Kafka 3.x)

```bash
# Generate a cluster UUID
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"

# Format the storage directory
bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties

# Start the server
bin/kafka-server-start.sh config/kraft/server.properties
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
| `scripts/kafka/` | Kafka installation and CLI shortcuts for topics, producers, consumers, and consumer groups |
| `scripts/setup/` | Environment setup (SDKman versions, environment variables) |

## Notes

- Kafka is run locally in **KRaft mode** (no ZooKeeper) as recommended for Kafka 3.x+
- Default broker address: `localhost:9092`
- All code examples use the official Apache Kafka Java client
