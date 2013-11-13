require 'spec_helper'
require_relative '../../../lib/dalli/stats_collector'

describe Dalli::StatsCollector do
  describe '#add' do
    it "should allow adding stats, and clear the stats when you pop them" do
      start = Time.now
      finish = start + 1
      subject.add('get', 'key', start, finish)
      subject.add('set', 'key2', start, finish)

      expect(subject.pop_stats).to eq(
        [
          { :command => 'get', :key => 'key', :latency => 1000.0, :utc => start.utc },
          { :command => 'set', :key => 'key2', :latency => 1000.0, :utc => start.utc }
        ]
      )

      expect(subject.pop_stats).to eq([])
    end
  end
end
