module LastFM
  module ImageReader
    def self.images(xml, xpath)
      result = Hashie::Mash.new
      
      ["small", "medium", "large", "extralarge", "mega"].each do |size|
        result.send("#{size}=", image(xml, xpath, size))
      end
      
      result
    end
    
    def self.image(xml, xpath, size)
      xml.at("#{xpath}[@size='#{size}']").content rescue nil
    end
  end
end
