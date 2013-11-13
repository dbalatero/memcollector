require 'spec_helper'
require_relative '../../../lib/dalli/remote_benchmarkable'

describe Dalli::RemoteBenchmarkable do
  class MockDalliServer
    def request(cmd, key, *args)
      sleep(0.001)
      :request
    end

    include Dalli::RemoteBenchmarkable
  end

  describe '#request' do
    subject { MockDalliServer.new }

    let(:collector) { double(:collector).as_null_object }

    before { Dalli::StatsCollector.stub(:new => collector) }

    it "should benchmark the request and save the result" do
      collector
        .should_receive(:add)
        .with('get', 'key', an_instance_of(Time), an_instance_of(Time))

      subject.request('get', 'key', :blah)
    end

    it "should return the value of the original request method" do
      subject.request('get', 'key').should == :request
    end
  end
end
