require 'socket'

module Dalli
  class StatsReporter
    def run!
      loop do
        sleep 15
        report!
      end
    end

  private

    def report!
      stats = Dalli::Server.pop_stats
      return if stats.empty?

      data = {
        :machine => machine,
        :pid => pid,
        :cache => 'memcached',
        :points => stats
      }.to_json

      # do POST request with `data`
    end

    def machine
      @machine ||= ENV['DYNO'] || Socket.gethostname
    end

    def pid
      @pid ||= Process.pid
    end
  end
end
