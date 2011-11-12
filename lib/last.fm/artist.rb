require_relative 'request_helper'
require_relative 'unimplemented'

module LastFM
  class Artist
    include RequestHelper
    include Unimplemented
    
    unimplemented methods: [:add_tags, :correction, :images, :info, :past_events, :podcast, :similar,
                     :user_tags, :top_albums, :top_fans, :top_tags, :remove_tag, :share, :shout]

    attr_reader :name, :listeners, :images, :url, :streamable, :similar_artists, :tags
    
    def initialize(name, attributes={})
      @name = name
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
          result << Artist.new(artist.at("name").content, {
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
    
    def info!
      xml = do_request(method: "artist.getinfo", artist: @name, autocorrect: 1)
      artist = xml.at("artist")
      @name = artist.at("name").content
      @url = artist.at("url").content
      @images = {
        small: artist.at('image[@size="small"]').content,
        medium: artist.at('image[@size="medium"]').content,
        large: artist.at('image[@size="large"]').content,
        extralarge: artist.at('image[@size="extralarge"]').content,
        mega: artist.at('image[@size="mega"]').content
      }
      @listeners = artist.at("listeners").content.to_i
      @streamable = artist.at("streamable").content == "1"
      @similar_artists = artist.xpath("//similar/artist").map{|a| a.at("name").content}
      @tags = artist.xpath("//tags/tag").map{|t| t.at("name").content}
      self
    end

    def top_tracks
      xml = do_request(method: "artist.gettoptracks", artist: @name, autocorrect: 1)
      
      top_tracks = []
      xml.xpath("//track").each do |track|
        top_tracks << Track.new(
          track.attributes["rank"].value.to_i,
          track.at("name").content,
          track.at("duration").content.to_i,
          track.at("playcount").content.to_i,
          track.at("listeners").content.to_i,
          track.at("url").content,
          track.at("streamable").content == "1",
          {
            small: (track.at('image[@size="small"]').content rescue nil),
            medium: (track.at('image[@size="medium"]').content rescue nil),
            large: (track.at('image[@size="large"]').content rescue nil),
            extralarge: (track.at('image[@size="extralarge"]').content rescue nil)
          }
        )
      end
      
      top_tracks
    end
    
    def events
      xml = do_request(method: "artist.getevents", artist: @name, autocorrect: 1)
      xml.remove_namespaces!
      # puts xml.to_xml(:indent => 2)
      events = []
      xml.xpath("//event").each do |e|
        events << Event.from_xml(e)
      end
      
      events
    end
    
    Track = Struct::new(:rank, :name, :duration, :playcount, :listeners, :url, :streamable, :images)
  end
end