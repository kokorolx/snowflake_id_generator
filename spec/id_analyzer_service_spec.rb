require 'id_analyzer_service'

RSpec.describe Snowflake::IdAnalyzer do
  let(:snowflake_id) { 1794023001365434368 }
  # {:timestamp=>1716563389518, :datacenter_id=>2, :worker_id=>5, :sequence=>0, :timestamp_utc=>2024-05-24 15:09:49 2172649/4194304 UTC

  describe '#initialize' do
    it 'creates a new instance of Snowflake::IdAnalyzer' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      expect(analyzer_service).to be_an_instance_of(Snowflake::IdAnalyzer)
    end
  end

  describe '#analyze' do
    it 'returns a hash with analyzed components' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result).to be_a(Hash)
      expect(analysis_result.keys).to contain_exactly(:timestamp, :datacenter_id, :worker_id, :sequence, :timestamp_utc)
    end

    it 'correctly analyzes the timestamp' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:timestamp]).to eq(1716563389518)
    end

    it 'correctly analyzes the datacenter_id' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:datacenter_id]).to eq(2)
    end

    it 'correctly analyzes the worker_id' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:worker_id]).to eq(5)
    end

    it 'correctly analyzes the sequence' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:sequence]).to eq(0)
    end

    it 'correctly analyzes the timestamp_utc' do
      analyzer_service = Snowflake::IdAnalyzer.new(snowflake_id)
      analysis_result = analyzer_service.analyze
      expected_utc_time = Time.utc(2024, 5, 24, 15, 9, 49).to_i
      expect(analysis_result[:timestamp_utc].to_i).to eq(expected_utc_time)
    end
  end
end
