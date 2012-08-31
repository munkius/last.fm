# encoding: utf-8
module StubResponse
  
  def stub_artist_response(arguments, options = {})
    autocorrect = false || arguments[:autocorrect]
    
    url = LastFM.base_url + arguments.map{|k,v| "&#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/#{arguments[:artist] || arguments[:mbid]}"
    fixture_path = "#{fixture_path}-autocorrect" if autocorrect
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    fixture_path.gsub!(/ø/,"o")
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end

  def stub_event_response(arguments, options = {})
    url = LastFM.base_url + arguments.map{|k,v| "&#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/#{arguments[:event]}"
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end
  
  def stub_user_response(arguments, options = {})
    url = LastFM.base_url + arguments.map{|k,v| "&#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/#{arguments[:user]}"
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end
  
  def stub_dummy_response(arguments, options = {})
    url = LastFM.base_url + arguments.map{|k,v| "&#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join
    sub_fixtures_path = arguments[:method].sub(/\./, "/")
    fixture_path = "../../fixtures/#{sub_fixtures_path}/dummy"
    fixture_path = File.expand_path("#{fixture_path}.xml", __FILE__)
    
    status = options[:status] || 200
    FakeWeb.register_uri(:get, url, :body => File.open(fixture_path, "rb").read, status: status)
  end

end