require 'spec_helper'
require 'id_analyzer_service'

RSpec.describe IdAnalyzerService do
  let(:snowflake_id) { 449210770878627840 }

  describe '#initialize' do
    it 'creates a new instance of IdAnalyzerService' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      expect(analyzer_service).to be_an_instance_of(IdAnalyzerService)
    end
  end

  describe '#analyze' do
    it 'returns a hash with analyzed components' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result).to be_a(Hash)
      expect(analysis_result.keys).to contain_exactly(:timestamp, :datacenter_id, :worker_id, :sequence, :timestamp_utc)
    end

    it 'correctly analyzes the timestamp' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:timestamp]).to eq(324167379040)
    end

    it 'correctly analyzes the datacenter_id' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:datacenter_id]).to eq(2)
    end

    it 'correctly analyzes the worker_id' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:worker_id]).to eq(0)
    end

    it 'correctly analyzes the sequence' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expect(analysis_result[:sequence]).to eq(0)
    end

    it 'correctly analyzes the timestamp_utc' do
      analyzer_service = IdAnalyzerService.new(snowflake_id)
      analysis_result = analyzer_service.analyze

      expected_utc_time = Time.utc(2022, 2, 28, 15, 49, 39)
      expect(analysis_result[:timestamp_utc]).to eq(expected_utc_time)
    end
  end
end
