module LastFM
  class User
    include RequestHelper
    include Unimplemented
    include Errors
    
    # private_class_method :new
    
    attr_reader :id, :name, :age, :bootstrap, :country, :gender, :images, :playcount, :playlist_count, :realname, :registered, :subscriber, :type, :url, :weight
    
    unimplemented methods: [:artist_tracks, :banned_tracks, :events, :friends, :loved_tracks, :neighbours,
                            :past_events, :personal_tags, :playlists, :recent_stations, :recent_tracks,
                            :recommended_artists, :recommended_events, :shouts, :top_albums, :top_tags,
                            :top_tracks, :weekly_album_chart, :weekly_artist_chart, :weekly_chart_list,
                            :weekly_track_chart, :shout]

    class << self
      def find(username)
        xml = do_request(method: "user.getinfo", user: username)
        user = xml.at("//user")
        self.from_xml(user) do |options|
          options[:id] = user.at("./id").content.to_i
          options[:age] = user.at("./age").content.to_i
          options[:bootstrap] = user.at("./bootstrap").content.to_i
          options[:country] = user.at("./country").content        
          options[:gender] = user.at("./gender").content
          options[:playcount] = user.at("./playcount").content.to_i
          options[:playlist_count] = user.at("./playlists").content.to_i
          options[:registered] = DateTime.parse(user.at("./registered").content)
          options[:subscriber] = user.at("./subscriber").content == "1"
          options[:type] = user.at("./type").content
        end
      end
      alias_method :info, :find
      
      def from_xml(user)
        return if user.nil?
        
        name = user.at("./name").content
        
        options = {}
        options[:images] = ImageReader::images(user, "./image")
        options[:realname] = user.at("./realname").content
        options[:url] = user.at("./url").content

        yield(options) if block_given?
        
        User.new(name, options)
      end
    end
    
    def find_top_artists
      xml = do_request(method: "user.gettopartists", user: @name)
      
      top_artists = []
      xml.xpath("//artist").each do |a|
        top_artists << Artist.from_xml(a)
      end
      
      @top_artists = top_artists
    end
    
  private

    def initialize(name, options)
      @name = name
      @id, @age, @bootstrap, @country, @gender, @images, @playcount, @playlist_count, @realname, @registered, @subscriber, @type, @url, @weight =
        options.delete(:id), options.delete(:age), options.delete(:bootstrap), options.delete(:country), options.delete(:gender), options.delete(:images), options.delete(:playcount), options.delete(:playlist_count), options.delete(:realname), options.delete(:registered), options.delete(:subscriber), options.delete(:type), options.delete(:url), options.delete(:weight)

      raise "Invalid options passed: #{options.keys.join(", ")}" if options.keys.size > 0
    end
  end
end