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

```bash
# First run only: format storage and start
bash scripts/kafka/kafka-start.sh

# Stop the broker
bash scripts/kafka/kafka-stop.sh
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
- Default broker address: `localhost:9092`
- All code examples use the official Apache Kafka Java client
