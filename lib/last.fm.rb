module LastFM
  class << self
    attr_accessor :api_key

    def configure
      yield self
    end
    
    def base_url
      "http://ws.audioscrobbler.com/2.0/?api_key=#{api_key}"
    end
  end
end


require 'hashie'

# internal helpers
require File.expand_path('../last.fm/helper/errors', __FILE__)
require File.expand_path('../last.fm/helper/image_reader', __FILE__)
require File.expand_path('../last.fm/helper/request_helper', __FILE__)
require File.expand_path('../last.fm/helper/unimplemented', __FILE__)

# external api
require File.expand_path('../last.fm/album', __FILE__)
require File.expand_path('../last.fm/artist', __FILE__)
require File.expand_path('../last.fm/artist_image', __FILE__)
require File.expand_path('../last.fm/event', __FILE__)
require File.expand_path('../last.fm/shout', __FILE__)
require File.expand_path('../last.fm/tag', __FILE__)
require File.expand_path('../last.fm/track', __FILE__)
require File.expand_path('../last.fm/user', __FILE__)

require File.expand_path('../last.fm/errors', __FILE__)