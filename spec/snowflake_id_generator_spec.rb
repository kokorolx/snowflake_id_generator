require 'snowflake_id_generator'

RSpec.describe Snowflake::IdGenerator do
  let(:datacenter_id) { 1 }
  let(:worker_id) { 1 }

  describe '#initialize' do
    it 'creates a new instance of Snowflake::IdGenerator' do
      generator = Snowflake::IdGenerator.new(datacenter_id, worker_id)
      expect(generator).to be_an_instance_of(Snowflake::IdGenerator)
    end

    it 'raises an error if datacenter_id is invalid' do
      expect { Snowflake::IdGenerator.new(32, worker_id) }.to raise_error(ArgumentError)
    end

    it 'raises an error if worker_id is invalid' do
      expect { Snowflake::IdGenerator.new(datacenter_id, 32) }.to raise_error(ArgumentError)
    end
  end

  describe '#next_id' do
    it 'generates unique IDs' do
      generator = Snowflake::IdGenerator.new(datacenter_id, worker_id)
      id1 = generator.next_id
      id2 = generator.next_id
      expect(id1).not_to eq(id2)
    end

    it 'generates IDs with correct structure' do
      generator = Snowflake::IdGenerator.new(datacenter_id, worker_id)
      id = generator.next_id
      expect(id).to be_an(Integer)
    end
  end
end
