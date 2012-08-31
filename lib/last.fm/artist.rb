module LastFM
  class Artist
    include RequestHelper
    include Unimplemented
    
    AUTHENTICATED_METHODS = [:add_tags, :tags_by_user, :remove_tag, :share, :shout]
    unimplemented methods: AUTHENTICATED_METHODS + [:correction, :podcast]

    attr_reader :name, :listeners, :mbid, :images, :match, :url, :streamable, :similar_artists, :tags
    alias_method :streamable?, :streamable
    
    class << self

      def from_xml(xml)
        name = xml.at("./name").content
        
        options = {}
        options[:images] = ImageReader::images(xml, "./image")
        options[:playcount] = xml.at("./playcount").content.to_i rescue nil
        options[:streamable] = xml.at("./streamable").content == "1"
        options[:mbid] = xml.at("./mbid").content
        options[:url] = xml.at("./url").content
        
        yield(xml, options) if block_given?
        Artist.new(name, options)
      end

      def find_by_name(name)
        find(artist: name, autocorrect: 1)
      end

      def find_by_mbid(mbid)
        find(mbid: mbid)
      end
      
      def find(options={})
        find_single("artist.getinfo", options, "/lfm/artist", Artist) do |artist, options|
          options[:listeners] = artist.at("./stats/listeners").content.to_i
          options[:similar_artists] = artist.xpath("//similar/artist").map{|a| a.at("./name").content}
          options[:tags] = artist.xpath("//tags/tag").map{|t| t.at("./name").content}
        end
      end
      
      def search(artist)
        find_stuff("artist.search", {artist: artist}, "//artist", Artist) do |artist, options|
          options[:listeners] = artist.at("./listeners").content.to_i rescue nil
        end
      end
    end

    def find_top_tracks
      find_stuff("artist.gettoptracks", {artist: @name, autocorrect: 1}, "//track", Track)
    end
    
    def find_events
      find_stuff("artist.getevents", {artist: @name, autocorrect: 1}, "//event", Event)
    end

    def find_similar_artists
      find_stuff("artist.getsimilar", {artist: @name}, "//similarartists/artist", Artist) do |artist, options|
        options[:match] = artist.at("./match").content.to_f
      end
    end
    
    def find_past_events
      find_stuff("artist.getpastevents", {artist: @name}, "//events/event", Event)
    end
    
    def find_top_fans
      find_stuff("artist.gettopfans", {artist: @name}, "//topfans/user", User) do |user, options|
        options[:weight] = user.at("./weight").content.to_i
      end
    end
    
    def find_top_albums
      find_stuff("artist.gettopalbums", {artist: @name}, "//topalbums/album", Album) do |album, options|
        options[:rank] = album.attributes["rank"].value.to_i
      end
    end
    
    def find_top_tags
      find_stuff("artist.gettoptags", {artist: @name}, "//toptags/tag", Tag) do |tag, options|
        options[:rank] = tag.attributes["rank"].value.to_i
      end
    end
    
    def find_images
      find_stuff("artist.getimages", {artist: @name}, "//images/image", ArtistImage)
    end
    
    def find_shouts
      find_stuff("artist.getshouts", {artist: @name}, "//shouts/shout", Shout)
    end
    
  private
  
    def initialize(name, options)
      options = options.dup
      @name = name
      @images, @listeners, @match, @playcount, @similar_artists, @streamable, @tags, @url, @mbid = 
        options.delete(:images), options.delete(:listeners), options.delete(:match), options.delete(:playcount), options.delete(:similar_artists), options.delete(:streamable), options.delete(:tags), options.delete(:url), options.delete(:mbid)
        raise "Invalid options passed: #{options.keys.join(", ")}" if options.keys.size > 0
    end
    
  end
end