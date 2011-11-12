require 'nokogiri'
require 'open-uri'

module LastFM
  module RequestHelper
    include Errors
    
    def self.included(base)
      base.extend ClassMethods
    end

    BASE_URL = "http://ws.audioscrobbler.com/2.0/?api_key=b25b959554ed76058ac220b7b2e0a026"
    
    def do_request(params)
      self.class.do_request(params)
    end
    
    def find_stuff(method, options={}, xpath, clazz, &block)
      self.class.find_stuff(method, options, xpath, clazz, &block)
    end
    
    def find_single(method, options={}, xpath, clazz, &block)
      self.class.find_single(method, options, xpath, clazz, &block)
    end
    
    module ClassMethods
      def do_request(params)
        url = BASE_URL + params.map{|k,v| "&#{k}=#{v}" }.join
        url = URI::escape(url)
        xml = Nokogiri::XML(open(url))
      end
      
      def find_stuff(method, options={}, xpath, clazz, &block)
        xml = do_request({method: method}.merge(options))
        xml.remove_namespaces!

        stuff = []
        xml.xpath(xpath).each do |xml|
          stuff << clazz.from_xml(xml) do |xml, options|
            yield(xml, options) if block_given?
          end
        end

        stuff
      end
      
      def find_single(method, options={}, xpath, clazz, &block)
        find_stuff(method, options, xpath, clazz, &block).first
      end
    end
  end
end