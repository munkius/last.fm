module LastFM
  class User
    include RequestHelper
    include Unimplemented
    include Errors
    
    # private_class_method :new
    
    attr_reader :id, :name, :age, :bootstrap, :country, :gender, :images, :playcount, :playlist_count, :realname, :registered, :subscriber, :type, :url
    
    unimplemented methods: [:artist_tracks, :banned_tracks, :events, :friends, :loved_tracks, :neighbours,
                            :past_events, :personal_tags, :playlists, :recent_stations, :recent_tracks,
                            :recommended_artists, :recommended_events, :shouts, :top_albums, :top_tags,
                            :top_tracks, :weekly_album_chart, :weekly_artist_chart, :weekly_chart_list,
                            :weekly_track_chart, :shout]

    class << self
      def find(username)
        xml = do_request(method: "user.getinfo", user: username)
        self.from_xml(xml)
      end
      alias_method :info, :find
      
      def from_xml(xml)
        user = xml.at("//user")
        
        return if user.nil?
        
        id = user.at("./id").content.to_i
        name = user.at("./name").content
        age = user.at("./age").content.to_i
        bootstrap = user.at("./bootstrap").content.to_i
        country = user.at("./country").content        
        gender = user.at("./gender").content
        images = ImageReader::images(user, "./image")
        playcount = user.at("./playcount").content.to_i
        playlist_count = user.at("./playlists").content.to_i
        realname = user.at("./realname").content
        registered = DateTime.parse(user.at("./registered").content)
        subscriber = user.at("./subscriber").content == "1"
        type = user.at("./type").content
        url = user.at("./url").content

        User.new(id, name, age, bootstrap, country, gender, images, playcount, playlist_count, realname, registered, subscriber, type, url)
      end
    end
    
    def top_artists
      xml = do_request(method: "user.gettopartists", user: @name)
      
      top_artists = []
      xml.xpath("//artist").each do |a|
        top_artists << Artist.from_xml(a)
      end
      
      @top_artists = top_artists
    end
    
  private

    def initialize(id, name, age, bootstrap, country, gender, images, playcount, playlist_count, realname, registered, subscriber, type, url)
      @id, @name, @age, @bootstrap, @country, @gender, @images, @playcount, @playlist_count, @realname, @registered, @subscriber, @type, @url =
        id, name, age, bootstrap, country, gender, images, playcount, playlist_count, realname, registered, subscriber, type, url
    end
  end
end