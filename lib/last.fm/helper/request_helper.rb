require 'nokogiri'
require 'net/http'
require 'open-uri'

module LastFM
  module RequestHelper
    include Errors
    
    MAX_RETRY_COUNT = 5
    
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
        
        begin
          if response.is_a? Net::HTTPSuccess
            return Nokogiri::XML(response.body)
          elsif response.is_a? Net::HTTPClientError
            handle_error(response)
          elsif response.is_a? Net::HTTPServerError
            raise LastFM::ConnectionError.new("Internal server error at Last.FM (#{url})", response)
          end
        rescue StandardError => e
          retry_count ||= 0; retry_count += 1
          if retry_count <= MAX_RETRY_COUNT
            sleep 1
            retry
          else
            raise e
          end
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
        begin
          error_code = xml.at("/lfm/error").attributes["code"].value.to_i
          if error_code == 10
            raise InvalidApiKey
          end
        rescue StandardError => e
          STDERR.puts response.body # for debug reasoning
          raise e
        end
        xml
      end
    end
  end
end