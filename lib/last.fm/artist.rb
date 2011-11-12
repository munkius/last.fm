module LastFM
  class Artist
    include RequestHelper
    include Unimplemented
    
    unimplemented methods: [:add_tags, :correction, :images_list, :past_events, :podcast, :similar,
                     :user_tags, :top_albums, :top_fans, :top_tags, :remove_tag, :share, :shout]

    attr_reader :name, :listeners, :images, :url, :streamable, :similar_artists, :tags
    
    class << self

      def from_xml(xml)
        name = xml.at("./name").content
        
        options = {}
        options[:images] = ImageReader::images(xml, "./image")
        options[:playcount] = xml.at("./playcount").content.to_i
        options[:streamable] = xml.at("./streamable").content == "1"
        options[:url] = xml.at("./url").content
        
        Artist.new(name, options)
      end

      def find(artistname)
        xml = do_request(method: "artist.getinfo", artist: artistname, autocorrect: 1)
        artist = xml.at("artist")
        
        return if artist.nil?
        
        name = artist.at("./name").content

        options = {}
        options[:url] = artist.at("./url").content
        options[:images] = ImageReader::images(artist, "./image")
        options[:listeners] = artist.at("./stats/listeners").content.to_i
        options[:streamable] = artist.at("./streamable").content == "1"
        options[:similar_artists] = artist.xpath("//similar/artist").map{|a| a.at("./name").content}
        options[:tags] = artist.xpath("//tags/tag").map{|t| t.at("./name").content}
        
        Artist.new(name, options)
      end
      
      alias_method :info, :find

      def search(artist)
        result = []
        xml = do_request(method: "artist.search", artist: artist)
        xml.xpath("//artist").each do |artist|
          result << Artist.new(artist.at("./name").content, {
            listeners: artist.at("./listeners").content.to_i,
            url: artist.at("./url").content,
            streamable: artist.at("./streamable").content == "1",
            images: ImageReader::images(artist, "./image")
          })
        end
        result
      end
    end

    def top_tracks
      xml = do_request(method: "artist.gettoptracks", artist: @name, autocorrect: 1)
      
      top_tracks = []
      xml.xpath("//track").each do |track|
        top_tracks << Track.new(
          track.attributes["rank"].value.to_i,
          track.at("./name").content,
          track.at("./duration").content.to_i,
          track.at("./playcount").content.to_i,
          track.at("./listeners").content.to_i,
          track.at("./url").content,
          track.at("./streamable").content == "1",
          ImageReader::images(track, "./image")
        )
      end
      
      top_tracks
    end
    
    def events
      xml = do_request(method: "artist.getevents", artist: @name, autocorrect: 1)
      xml.remove_namespaces!

      events = []
      xml.xpath("//event").each do |e|
        events << Event.from_xml(e)
      end
      
      events
    end

  private

    def initialize(name, options)
      options = options.dup
      @name = name
      @images, @listeners, @playcount, @similar_artists, @streamable, @tags, @url = 
        options.delete(:images), options.delete(:listeners), options.delete(:playcount), options.delete(:similar_artists), options.delete(:streamable), options.delete(:tags), options.delete(:url)
        raise "Invalid options passed: #{options.keys.join(", ")}" if options.keys.size > 0
    end
 
    Track = Struct::new(:rank, :name, :duration, :playcount, :listeners, :url, :streamable, :images)
  end
end