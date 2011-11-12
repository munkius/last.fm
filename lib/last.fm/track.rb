module LastFM
  class Track < Hashie::Mash

    class << self
      def from_xml(xml)
        result = Track.new
        
        result.rank = xml.attributes["rank"].value.to_i
        result.name = xml.at("./name").content
        result.duration = xml.at("./duration").content.to_i
        result.playcount = xml.at("./playcount").content.to_i
        result.listeners = xml.at("./listeners").content.to_i
        result.url = xml.at("./url").content
        result.streamable = xml.at("./streamable").content == "1"
        result.images = ImageReader::images(xml, "./image")

        result
      end
    end
  end
end
