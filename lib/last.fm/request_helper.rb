require 'nokogiri'
require 'open-uri'

module LastFM
  module RequestHelper

    def self.included(base)
      base.extend ClassMethods
    end

    BASE_URL = "http://ws.audioscrobbler.com/2.0/?api_key=b25b959554ed76058ac220b7b2e0a026"
    
    def do_request(params)
      self.class.do_request(params)
    end
    
    module ClassMethods
      def do_request(params)
        url = BASE_URL + params.map{|k,v| "&#{k}=#{v}" }.join
        url = URI::escape(url)
        Nokogiri::XML(open(url))
      end
    end
  end
end