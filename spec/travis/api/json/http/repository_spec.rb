require 'spec_helper'
require 'travis/api'
require 'travis/api/support/stubs'

describe Travis::Api::Json::Http::Repository do
  include Support::Stubs, Support::Formats

  let(:data) { Travis::Api::Json::Http::Repository.new(repository).data }

  it 'data' do
    data.except('public_key').should == {
      'id' => repository.id,
      'slug' => 'svenfuchs/minimal',
      'description' => 'the repo description',
      'last_build_id' => repository.last_build_id,
      'last_build_number' => repository.last_build_number,
      'last_build_started_at' => json_format_time(Time.now.utc - 1.minute),
      'last_build_finished_at' => json_format_time(Time.now.utc),
      'last_build_status' => repository.last_build_status, # still here for backwards compatibility
      'last_build_result' => repository.last_build_status,
      'last_build_language' => 'ruby',
      'last_build_duration' => 60
    }
    data['public_key'].should =~ /-----BEGIN.*PUBLIC KEY-----/
  end
end
