require 'spec_helper'

describe LastFM do
  include StubResponse
  
  it "should have a configurable API key" do
    LastFM.configure do |config|
      config.api_key = "foobar"
    end
    LastFM.api_key.should == "foobar"
  end
  
  it "should tell me when the API key is invalid" do
    LastFM.configure do |config|
      config.api_key = "invalid-key"
    end
    stub_user_response({method: "user.getinfo", user: "invalid_api_key"}, status: 400)
    lambda{LastFM::User.find("invalid_api_key")}.should raise_error(LastFM::InvalidApiKey)
  end
end