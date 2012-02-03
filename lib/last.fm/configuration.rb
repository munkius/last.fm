module LastFM
  module Configuration
    attr_accessor :api_key

    def configure
      yield self
    end

    def base_url
      "http://ws.audioscrobbler.com/2.0/?api_key=#{api_key}"
    end

  end
end