require 'rspec'
require 'fakeweb'
require 'last.fm'

LastFM.configure do |config|
  config.api_key = "foo"
end

load File.expand_path('../support/stub_response.rb', __FILE__)

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.mock_with :mocha
end
