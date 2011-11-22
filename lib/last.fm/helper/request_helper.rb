require 'nokogiri'
require 'net/http'
require 'open-uri'

module LastFM
  module RequestHelper
    include Errors
    
    def self.included(base)
      base.extend ClassMethods
    end

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
        url = LastFM.base_url + params.map{|k,v| "&#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join
        response = Net::HTTP.get_response(URI(url))
        
        if response.is_a? Net::HTTPSuccess
          Nokogiri::XML(response.body)
        else
          handle_error(response) if response != Net::HTTPSuccess
        end
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
      
    private
    
      def handle_error(response)
        xml = Nokogiri::XML(response.body)
        error_code = xml.at("/lfm/error").attributes["code"].value.to_i
        
        if error_code == 10
          raise InvalidApiKey
        end
        
        xml
      end
    end
  end
end