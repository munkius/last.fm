module LastFM
  class Shout < Hashie::Mash
    class << self
      def from_xml(xml)
        result = Shout.new
        result.body = xml.at("./body").content
        result.author = xml.at("./author").content
        result.date = DateTime.parse(xml.at("./date").content)
        
        result
      end
    end
  end
end