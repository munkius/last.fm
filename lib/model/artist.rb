require 'open-uri'
require 'nokogiri'
require_relative 'request_helper'

module LastFM
  class Artist
    extend RequestHelper
    
    UNIMPLEMENTED = [:add_tags, :correction, :events, :images, :info, :past_events, :podcast, :similar,
                     :tags, :top_albums, :top_fans, :top_tags, :top_tracks, :remove_tag, :share, :shout]

    UNIMPLEMENTED.each do |unimplemented_method|
     define_method(unimplemented_method) do
       raise "Not implemented"
     end
    end

    attr_reader :name, :listeners, :images, :url, :streamable
    
    def initialize(attributes={})
      @name = attributes[:name]
      @listeners = attributes[:listeners]
      @url = attributes[:url]
      @images = attributes[:images]
      @streamable = attributes[:streamable]
    end
    
    class << self

      def search(artist)
        result = []
        xml = do_request(method: "artist.search", artist: artist)
        xml.xpath("//artist").each do |artist|
          result << Artist.new({
            name: artist.at("name").content,
            listeners: artist.at("listeners").content.to_i,
            url: artist.at("url").content,
            streamable: artist.at("streamable").content == "1",
            images: {
              small: artist.at('image[@size="small"]').content,
              medium: artist.at('image[@size="medium"]').content,
              large: artist.at('image[@size="large"]').content,
              extralarge: artist.at('image[@size="extralarge"]').content,
              mega: artist.at('image[@size="mega"]').content
            }
          })
        end
        result
      end
    end
  end
end