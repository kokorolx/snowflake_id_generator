require './snowflake_id_generator'

class IdAnalyzerService
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
    timestamp += SnowflakeIdGenerator::EPOCH
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
