# Snowflake ID Generator

Snowflake ID Generator is a Ruby gem for generating unique IDs across multiple data centers and workers simultaneously using a distributed system. It provides a simple and efficient way to generate globally unique identifiers suitable for distributed applications and high-throughput systems.

## Features

- **Distributed ID Generation**: Generate unique Snowflake IDs across multiple data centers and workers.
- **High Throughput**: Capable of generating billions of unique IDs per second, making it suitable for high-throughput applications.
- **Long-Term Uniqueness**: Timestamp component ensures uniqueness for many years into the future.
- **Scalable**: Supports thousands of data centers and workers simultaneously, enabling distributed systems to generate unique IDs efficiently.

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

