module LastFM
  class Tag < Hashie::Mash
  
    class << self
      def from_xml(xml)
        result = Tag.new
        result.name = xml.at("./name").content
        result.url = xml.at("./url").content
        
        result
      end
    end
  end
end