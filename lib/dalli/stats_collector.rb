require 'thread'

module Dalli
  class StatsCollector
    def initialize
      @mutex = Mutex.new
      @stats = []
    end

    # Adds a single statistic to the list (thread-safe).
    def add(command, key, start, finish)
      @mutex.synchronize do
        @stats << [command, key, start, finish]
      end
    end

    # Grabs the current list of statistics (thread-safe), resets it to a
    # blank array, and returns the stats.
    def pop_stats
      stats = nil

      @mutex.synchronize do
        stats = @stats
        @stats = []
      end

      stats.map do |stat|
        {
          :command => stat[0],
          :key => stat[1],
          :latency => (stat[3] - stat[2]).to_f * 1000,
          :utc => stat[2].utc
        }
      end
    end
  end
end
