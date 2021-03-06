require 'spec_helper'
require 'travis/api'
require 'travis/api/support/stubs'

describe Travis::Api::Json::Pusher::Worker do
  include Support::Stubs, Support::Formats

  let(:data)   { Travis::Api::Json::Pusher::Worker.new(worker).data }

  it 'data' do
    data.should == {
      'id' => 1,
      'host' => 'ruby-1.worker.travis-ci.org',
      'name' => 'ruby-1',
      'state' => 'created',
      'last_error' => nil,
      'payload' => nil
    }
  end
end


