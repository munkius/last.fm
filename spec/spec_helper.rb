require 'rspec'
require 'fakeweb'
require 'last.fm'
require 'cgi'

load File.expand_path('../support/stub_response.rb', __FILE__)

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.mock_with :mocha
  
  config.before :each do
    LastFM.configure do |config|
      config.api_key = "b25b959554ed76058ac220b7b2e0a026"
    end
  end
end
