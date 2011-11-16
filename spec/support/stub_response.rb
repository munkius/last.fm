# encoding: utf-8
module StubResponse
  
  BASE_URL = "http://ws.audioscrobbler.com/2.0/?api_key=b25b959554ed76058ac220b7b2e0a026"
  
  def stub_artist_response(arguments, options = {})
    autocorrect = false || arguments[:autocorrect]
    
    url = BASE_URL + arguments.map{|k,v| "&#{k}=#{v}"}.join
    url = URI::escape(url)
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/#{arguments[:artist]}"
    fixture_path = "#{fixture_path}-autocorrect" if autocorrect
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    fixture_path.gsub!(/ø/,"o")
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end
  
  def stub_user_response(arguments, options = {})
    url = BASE_URL + arguments.map{|k,v| "&#{k}=#{v}"}.join
    url = URI::escape(url)
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/#{arguments[:user]}"
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end
end