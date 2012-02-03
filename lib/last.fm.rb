require 'hashie'

# internal helpers
require File.expand_path('../last.fm/helper/errors', __FILE__)
require File.expand_path('../last.fm/helper/image_reader', __FILE__)
require File.expand_path('../last.fm/helper/request_helper', __FILE__)
require File.expand_path('../last.fm/helper/unimplemented', __FILE__)

# just... stuff
require File.expand_path('../last.fm/configuration', __FILE__)
require File.expand_path('../last.fm/logger', __FILE__)

# errors
require File.expand_path('../last.fm/errors', __FILE__)

# external api
require File.expand_path('../last.fm/album', __FILE__)
require File.expand_path('../last.fm/artist', __FILE__)
require File.expand_path('../last.fm/artist_image', __FILE__)
require File.expand_path('../last.fm/event', __FILE__)
require File.expand_path('../last.fm/shout', __FILE__)
require File.expand_path('../last.fm/tag', __FILE__)
require File.expand_path('../last.fm/track', __FILE__)
require File.expand_path('../last.fm/user', __FILE__)

module LastFM
  extend Configuration
  extend Logger
end