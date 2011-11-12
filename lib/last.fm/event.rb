module LastFM
  class Event < Hashie::Mash
    
    class << self
      
      def from_xml(xml)
        event = Event.new
        event.id = xml.at("./id").content.to_i
        event.title = xml.at("./title").content
        event.artists = xml.xpath("./artists/artist").map{|a| a.content}
        event.headliner = xml.at("./artists/headliner").content
        event.venue = Hashie::Mash.new
        event.venue.id = xml.at("./venue/id").content.to_i
        event.venue.name = xml.at("./venue/name").content
        event.venue.location = Hashie::Mash.new
        event.venue.location.city = xml.at("./venue/location/city").content
        event.venue.location.country = xml.at("./venue/location/country").content
        event.venue.location.street = xml.at("./venue/location/street").content
        event.venue.location.postalcode = xml.at("./venue/location/postalcode").content
        event.venue.location.geo = Hashie::Mash.new
        event.venue.location.geo.lat = xml.at("./venue/location/point/lat").content.to_f
        event.venue.location.geo.long = xml.at("./venue/location/point/long").content.to_f
        event.venue.url = xml.at("./venue/url").content
        event.venue.website = xml.at("./venue/website").content
        event.venue.phonenumber = xml.at("./venue/phonenumber").content
        event.venue.images = ImageReader::images(xml, "./venue/image")
        event.start_date = DateTime.parse(xml.at("./startDate").content)
        event.description = xml.at("./description").content
        event.images = ImageReader::images(xml, "./image")
        event.attendance = xml.at("./attendance").content.to_i
        event.reviews = xml.at("./reviews").content.to_i
        event.tag = xml.at("./tag").content
        event.url = xml.at("./url").content
        event.website = xml.at("./website").content
        # # TODO: event.tickets.should == ""
        event.cancelled = xml.at("./cancelled").content == "1"
        event.tags = xml.xpath("./tags/tag").map{|t| t.content }
        
        event
      end
    end
  end
end