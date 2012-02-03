module LastFM
  class InvalidApiKey < StandardError; end
  
  class ConnectionError < StandardError

    attr_reader :message, :response

    def initialize(message, response)
      @message, @response = message, response
    end

  end
  
end