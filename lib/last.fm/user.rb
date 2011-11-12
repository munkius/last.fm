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
      def find(user)
        find_single("user.getinfo", {user: user}, "/lfm/user", User) do |user, options|
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
      
      def from_xml(xml)
        return if xml.nil?
        
        name = xml.at("./name").content
        
        options = {}
        options[:images] = ImageReader::images(xml, "./image")
        options[:realname] = xml.at("./realname").content
        options[:url] = xml.at("./url").content

        yield(xml, options) if block_given?
        
        User.new(name, options)
      end
    end
    
    def find_top_artists
      find_stuff("user.gettopartists", {user: @name}, "//artist", Artist)
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