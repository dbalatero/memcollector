require_relative 'stats_collector'

module Dalli
  module RemoteBenchmarkable
    def self.included(base)
      base.class_eval do
        alias_method :request_without_remote_benchmarking, :request
        alias_method :request, :request_with_remote_benchmarking
      end

      base.extend(ClassMethods)
    end

    def request_with_remote_benchmarking(*args, &block)
      start = Time.now
      result = request_without_remote_benchmarking(*args, &block)
      finish = Time.now

      command = args[0]
      key = args[1]

      self.class.memcachier_stats.add(command, key, start, finish)

      result
    end

    module ClassMethods
      def memcachier_stats
        @memcachier_stats ||= Dalli::StatsCollector.new
      end
    end
  end
end
