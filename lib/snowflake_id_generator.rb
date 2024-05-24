class SnowflakeIdGenerator
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

  attr_reader :datacenter_id, :worker_id, :sequence, :last_timestamp

  def initialize(datacenter_id, worker_id)
    if datacenter_id > MAX_DATACENTER_ID || datacenter_id < 0
      raise ArgumentError, "datacenter_id must be between 0 and #{MAX_DATACENTER_ID}"
    end

    if worker_id > MAX_WORKER_ID || worker_id < 0
      raise ArgumentError, "worker_id must be between 0 and #{MAX_WORKER_ID}"
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
      @sequence = (@sequence + 1) & MAX_SEQUENCE
      if @sequence == 0
        timestamp = wait_for_next_millis(@last_timestamp)
      end
    else
      @sequence = 0
    end

    @last_timestamp = timestamp

    p "timestamp - EPOCH: #{timestamp - EPOCH}"

    ((timestamp - EPOCH) << TIMESTAMP_SHIFT) |
      (@datacenter_id << DATACENTER_ID_SHIFT) |
      (@worker_id << WORKER_ID_SHIFT) |
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
