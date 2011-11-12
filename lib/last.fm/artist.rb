module LastFM
  class Artist
    include RequestHelper
    include Unimplemented
    
    unimplemented methods: [:add_tags, :correction, :find_images, :podcast,
                     :user_tags, :remove_tag, :share, :shout]

    attr_reader :name, :listeners, :images, :match, :url, :streamable, :similar_artists, :tags
    alias_method :streamable?, :streamable
    
    class << self

      def from_xml(xml)
        name = xml.at("./name").content
        
        options = {}
        options[:images] = ImageReader::images(xml, "./image")
        options[:playcount] = xml.at("./playcount").content.to_i rescue nil
        options[:streamable] = xml.at("./streamable").content == "1"
        options[:url] = xml.at("./url").content
        
        yield(options) if block_given?
        Artist.new(name, options)
      end

      def find(artistname)
        xml = do_request(method: "artist.getinfo", artist: artistname, autocorrect: 1)
        artist = xml.at("artist")
        return if artist.nil?
        
        self.from_xml(artist) do |options|
          options[:listeners] = artist.at("./stats/listeners").content.to_i
          options[:similar_artists] = artist.xpath("//similar/artist").map{|a| a.at("./name").content}
          options[:tags] = artist.xpath("//tags/tag").map{|t| t.at("./name").content}
        end
        
      end
      
      alias_method :info, :find

      def search(artist)
        result = []
        xml = do_request(method: "artist.search", artist: artist)
        xml.xpath("//artist").each do |artist|
          result << self.from_xml(artist) do |options|
            options[:listeners] = artist.at("./listeners").content.to_i
          end
        end
        result
      end
    end

    def find_top_tracks
      xml = do_request(method: "artist.gettoptracks", artist: @name, autocorrect: 1)
      
      top_tracks = []
      xml.xpath("//track").each do |t|
        top_tracks << Track.from_xml(t)
      end
      
      top_tracks
    end
    
    def find_events
      xml = do_request(method: "artist.getevents", artist: @name, autocorrect: 1)
      xml.remove_namespaces!

      events = []
      xml.xpath("//event").each do |e|
        events << Event.from_xml(e)
      end
      
      events
    end

    def find_similar_artists
      xml = do_request(method: "artist.getsimilar", artist: @name)
      similar = []
      xml.xpath("//similarartists/artist").each do |a|
        similar << Artist.from_xml(a) do |options|
          options[:match] = a.at("./match").content.to_f
        end
      end
      
      similar
    end
    
    def find_past_events
      xml = do_request(method: "artist.getpastevents", artist: @name)
      xml.remove_namespaces!
      past_events = []
      xml.xpath("//events/event").each do |e|
        past_events << Event.from_xml(e)
      end
      
      past_events
    end
    
    def find_top_fans
      xml = do_request(method: "artist.gettopfans", artist: @name)
      top_fans = []
      xml.xpath("//topfans/user").each do |u|
        top_fans << User.from_xml(u) do |options|
          options[:weight] = u.at("./weight").content.to_i
        end
      end
      
      top_fans
    end
    
    def find_top_albums
      xml = do_request(method: "artist.gettopalbums", artist: @name)
      top_albums = []
      xml.xpath("//topalbums/album").each do |a|
        top_albums << Album.from_xml(a) do |options|
          options[:rank] = a.attributes["rank"].value.to_i
        end
      end
      
      top_albums
    end
    
    def find_top_tags
      xml = do_request(method: "artist.gettoptags", artist: @name)
      top_tags = []
      xml.xpath("//toptags/tag").each do |a|
        top_tags << Tag.from_xml(a) do |options|
          options[:rank] = a.attributes["rank"].value.to_i
        end
      end
      
      top_tags
    end
    
  private

    def initialize(name, options)
      options = options.dup
      @name = name
      @images, @listeners, @match, @playcount, @similar_artists, @streamable, @tags, @url = 
        options.delete(:images), options.delete(:listeners), options.delete(:match), options.delete(:playcount), options.delete(:similar_artists), options.delete(:streamable), options.delete(:tags), options.delete(:url)
        raise "Invalid options passed: #{options.keys.join(", ")}" if options.keys.size > 0
    end
    
  end
end