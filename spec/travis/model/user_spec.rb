require 'spec_helper'
require 'support/active_record'

describe User do
  include Support::ActiveRecord

  let(:user)    { FactoryGirl.build(:user) }
  let(:payload) { GITHUB_PAYLOADS[:oauth] }

  describe 'find_or_create_for_oauth' do
    def user(payload)
      User.find_or_create_for_oauth(payload)
    end

    it 'marks new users as such' do
      user(payload).should be_recently_signed_up
      user(payload).should_not be_recently_signed_up
    end

    it 'updates changed attributes' do
      user(payload).attributes.slice(*GITHUB_OAUTH_DATA.keys).should == GITHUB_OAUTH_DATA
    end
  end

  describe 'user_data_from_oauth' do
    it 'returns required data' do
      User.user_data_from_oauth(payload).should == GITHUB_OAUTH_DATA
    end
  end

  describe 'organization_ids' do
    let!(:travis)  { Factory(:org, :login => 'travis') }
    let!(:sinatra) { Factory(:org, :login => 'sinatra') }

    before :each do
     user.organizations << travis
     user.save!
    end

    it 'contains the ids of organizations that the user is a member of' do
      user.organization_ids.should include(travis.id)
    end

    it 'does not contain the ids of organizations that the user is not a member of' do
      user.organization_ids.should_not include(sinatra.id)
    end
  end

  describe 'profile_image_hash' do
    it "returns gravatar_id if it's present" do
      user.gravatar_id = '41193cdbffbf06be0cdf231b28c54b18'
      user.profile_image_hash.should == '41193cdbffbf06be0cdf231b28c54b18'
    end

    it 'returns a MD5 hash of the email if no gravatar_id and an email is set' do
      user.gravatar_id = nil
      user.profile_image_hash.should == Digest::MD5.hexdigest(user.email)
    end

    it 'returns 32 zeros if no gravatar_id or email is set' do
      user.gravatar_id = nil
      user.email = nil
      user.profile_image_hash.should == '0' * 32
    end
  end

  describe 'authenticated_on_github' do
    let(:user) { User.find_or_create_for_oauth(payload) }

    before do
      WebMock.stub_request(:get, "https://api.github.com/user").
        with(:headers => {'Authorization' => "token #{payload["credentials"]["token"]}"}).
        to_return(:status => 200, :body => payload.to_json, :headers => {})
    end

    it 'should log the user in' do
      user.authenticated_on_github do
        GH['/user']["name"].should be == payload["name"]
      end
    end
  end

  describe 'github_service_hooks' do
    let!(:repository) { Factory(:repository, :name => 'safemode', :active => true) }

    it "contains the user's service_hooks (i.e. repository data from github)" do
      service_hook = user.github_service_hooks.first
      service_hook.uid.should == 'svenfuchs:safemode'
      service_hook.owner_name.should == 'svenfuchs'
      service_hook.name.should == 'safemode'
      service_hook.description.should include('A library for safe evaluation of Ruby code')
      service_hook.url.should == 'https://github.com/svenfuchs/safemode'
      service_hook.active.should be_true
    end
  end
end
