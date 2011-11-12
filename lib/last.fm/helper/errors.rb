module LastFM
  module Errors
    ERRORS = {
      error_2: "Invalid service - This service does not exist",
      error_3: "Invalid Method - No method with that name in this package",
      error_4: "Authentication Failed - You do not have permissions to access the service",
      error_5: "Invalid format - This service doesn't exist in that format",
      error_6: "Invalid parameters - Your request is missing a required parameter",
      error_7: "Invalid resource specified",
      error_8: "Operation failed - Something else went wrong",
      error_9: "Invalid session key - Please re-authenticate",
     error_10: "Invalid API key - You must be granted a valid key by last.fm",
     error_11: "Service Offline - This service is temporarily offline. Try again later.",
     error_13: "Invalid method signature supplied",
     error_16: "There was a temporary error processing your request. Please try again",
     error_26: "Suspended API key - Access for your account has been suspended, please contact Last.fm",
     error_29: "Rate limit exceeded - Your IP has made too many requests in a short period"
    }
   
    attr_reader :error
   
  end
end