module LastFM
  class ArtistImage < Hashie::Mash
    class << self
      def from_xml(xml)
        result = ArtistImage.new
        
        result.title = xml.at("./title").content
        result.url = xml.at("./url").content
        result.date_added = DateTime.parse(xml.at("./dateadded").content)
        result.format = xml.at("./format").content
        result.sizes = Hashie::Mash.new
        # TODO: image size attributes?
        result.sizes = ImageReader::images(xml, ".//sizes/size", size_attribute: "name")
        result.votes = Hashie::Mash.new
        result.votes.thumbsup = xml.at("./votes/thumbsup").content.to_i
        result.votes.thumbsdown = xml.at("./votes/thumbsdown").content.to_i
        
        result
      end
    end
  end
end