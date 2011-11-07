module LastFM
  class User
    include RequestHelper
    include Unimplemented
    include Errors
    
    unimplemented methods: [:artist_tracks, :banned_tracks, :events, :friends, :info, :loved_tracks, :neighbours,
                            :past_events, :personal_tags, :playlists, :recent_stations, :recent_tracks,
                            :recommended_artists, :recommended_events, :shouts, :top_albums, :top_tags,
                            :top_tracks, :weekly_album_chart, :weekly_artist_chart, :weekly_chart_list,
                            :weekly_track_chart, :shout]
                  
    def initialize(name)
      @name = name
    end
    
    def top_artists
      xml = do_request(method: "user.gettopartists", user: @name)
      
      top_artists = []
      xml.xpath("//artist").each do |artist|
        top_artists << Artist.new(artist.at("name").content, {
          playcount: artist.at("playcount").content.to_i,
          url: artist.at("url").content,
          images: {
            small: artist.at('image[@size="small"]').content,
            medium: artist.at('image[@size="medium"]').content,
            large: artist.at('image[@size="large"]').content,
            extralarge: artist.at('image[@size="extralarge"]').content,
            mega: artist.at('image[@size="mega"]').content
          }
        })
      end
      
      @top_artists = top_artists
    end
  end
end