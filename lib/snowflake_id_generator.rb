module Snowflake
  EPOCH = 1288834974657 # Custom epoch (January 1, 2024)
  WORKER_ID_BITS = 5
  DATACENTER_ID_BITS = 5
  SEQUENCE_BITS = 12

  MAX_WORKER_ID = -1 ^ (-1 << WORKER_ID_BITS)
  MAX_DATACENTER_ID = -1 ^ (-1 << DATACENTER_ID_BITS)
  MAX_SEQUENCE = -1 ^ (-1 << SEQUENCE_BITS)

  WORKER_ID_SHIFT = SEQUENCE_BITS
  DATACENTER_ID_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS
  TIMESTAMP_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS + DATACENTER_ID_BITS

  class IdGenerator

    attr_reader :datacenter_id, :worker_id, :sequence, :last_timestamp

    def initialize(datacenter_id, worker_id)
      if datacenter_id > Snowflake::MAX_DATACENTER_ID || datacenter_id < 0
        raise ArgumentError, "datacenter_id must be between 0 and #{Snowflake::MAX_DATACENTER_ID}"
      end

      if worker_id > Snowflake::MAX_WORKER_ID || worker_id < 0
        raise ArgumentError, "worker_id must be between 0 and #{Snowflake::MAX_WORKER_ID}"
      end

      @datacenter_id = datacenter_id
      @worker_id = worker_id
      @sequence = 0
      @last_timestamp = -1
    end

    def next_id
      timestamp = current_time_millis

      if timestamp < @last_timestamp
        raise "Clock moved backwards. Refusing to generate id for #{@last_timestamp - timestamp} milliseconds"
      end

      if @last_timestamp == timestamp
        @sequence = (@sequence + 1) & Snowflake::MAX_SEQUENCE
        if @sequence == 0
          timestamp = wait_for_next_millis(@last_timestamp)
        end
      else
        @sequence = 0
      end

      @last_timestamp = timestamp

      p "timestamp - EPOCH: #{timestamp - Snowflake::EPOCH}"

      ((timestamp - Snowflake::EPOCH) << Snowflake::TIMESTAMP_SHIFT) |
        (@datacenter_id << Snowflake::DATACENTER_ID_SHIFT) |
        (@worker_id << Snowflake::WORKER_ID_SHIFT) |
        @sequence
    end

    private

    def current_time_millis
      (Time.now.to_f * 1000).to_i
    end

    def wait_for_next_millis(last_timestamp)
      timestamp = current_time_millis
      while timestamp <= last_timestamp
        timestamp = current_time_millis
      end
      timestamp
    end
  end

  class IdAnalyzer
    def initialize(id)
      @id = id.to_i
      @binary_id = @id.to_s(2).rjust(64, '0')
    end

    def analyze
      {
        timestamp: extract_timestamp,
        datacenter_id: extract_datacenter_id,
        worker_id: extract_worker_id,
        sequence: extract_sequence,
        timestamp_utc: timestamp_to_utc(extract_timestamp)
      }
    end

    private

    def extract_timestamp
      # Extract timestamp bits from the binary ID
      timestamp_bits = @binary_id[0..41]
      # Convert timestamp bits to integer
      timestamp = timestamp_bits.to_i(2)
      # Add the dynamic epoch (based on the first 41 bits of the ID)
      timestamp += Snowflake::EPOCH
      timestamp
    end

    def extract_datacenter_id
      @binary_id[42..46].to_i(2)
    end

    def extract_worker_id
      @binary_id[47..51].to_i(2)
    end

    def extract_sequence
      @binary_id[52..63].to_i(2)
    end

    def timestamp_to_utc(timestamp)
      Time.at(timestamp / 1000.0).utc
    end
  end
end


# datacenter_id = ENV['DATACENTER_ID'].to_i
# worker_id = ENV['WORKER_ID'].to_i
# @generator = Snowflake::IdGenerator.new(datacenter_id, worker_id)
# p id = @generator.next_id

# p analyzer = Snowflake::IdAnalyzer.new(id).analyze