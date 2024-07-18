# Snowflake ID Generator

Snowflake ID Generator is a Ruby gem for generating unique IDs across multiple data centers and workers simultaneously using a distributed system. It provides a simple and efficient way to generate globally unique identifiers suitable for distributed applications and high-throughput systems.

## Features

- **Distributed ID Generation**: Generate unique Snowflake IDs across multiple data centers and workers.
- **High Throughput**: Capable of generating billions of unique IDs per second, making it suitable for high-throughput applications.
- **Long-Term Uniqueness**: Timestamp component ensures uniqueness for many years into the future.
- **Scalable**: Supports thousands of data centers and workers simultaneously, enabling distributed systems to generate unique IDs efficiently.

## Snowflake ID Generator Calculator

### Structure of Snowflake ID
- **Timestamp (41 bits)**
  - Allows for \(2^{41} = 2,199,023,255,552\) milliseconds since a custom epoch.
- **Data Center ID (5 bits)**
  - Allows for \(2^5 = 32\) data centers.
- **Worker Node ID (5 bits)**
  - Allows for \(2^5 = 32\) worker nodes per data center.
- **Sequence Number (12 bits)**
  - Allows for \(2^{12} = 4096\) unique IDs per millisecond per node.

### Calculations

- **Maximum Number of Servers**

  - Max Servers = Max Data Centers * Max Worker Nodes
  - Max Servers = 32 * 32 = 1024


- **Maximum IDs per Server per Second**
  - Max IDs per Server per Second = 4096 * 1000
  - Max IDs per Server per Second = 4,096,000

- **Maximum Total IDs per Second**
  - Max Total IDs per Second = Max Servers * Max IDs per Server per Second
  - Max Total IDs per Second = 1024 * 4,096,000 = 4,194,304,000


### Summary
- **Maximum number of servers (data centers * worker nodes)**: 1024
- **Maximum number of IDs per server per second**: 4,096,000
- **Maximum total number of IDs per second**: 4,194,304,000

Thus, the Snowflake ID generator can support up to 1024 servers and generate a total of approximately 4.19 billion unique IDs per second across all servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snowflake_id_generator'
```

And then
```
$ bundle install
```

Or install it yourself as:
```
$ gem install snowflake_id_generator
```

## Usage
```ruby
require 'snowflake_id_generator'
```

# Create a new Snowflake ID generator
```ruby
generator = Snowflake::IdGenerator.new(datacenter_id, worker_id)
```

# Generate a unique ID
```ruby
id = generator.next_id
```

# Analyze the generated ID
```ruby
analyzer = Snowflake::IdAnalyzer.new(id)
analysis_result = analyzer.analyze
```

