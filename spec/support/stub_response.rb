module StubResponse
  
  BASE_URL = "http://ws.audioscrobbler.com/2.0/?api_key=b25b959554ed76058ac220b7b2e0a026"
  
  def stub_response(arguments)
    url = BASE_URL + arguments.map{|k,v| "&#{k}=#{v}"}.join
    url = URI::escape(url)
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = File.expand_path("../../fixtures/#{sub_fixtures_path}/#{arguments[:artist]}.xml", __FILE__)
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read)
  end
end