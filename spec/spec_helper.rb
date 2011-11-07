require 'rspec'
require 'fakeweb'
require 'last.fm'

load File.expand_path('../support/stub_response.rb', __FILE__)

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.mock_with :mocha  
end
