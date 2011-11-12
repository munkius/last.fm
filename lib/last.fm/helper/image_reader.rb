module LastFM
  module ImageReader
    def images(xml, xpath)
      result = Hashie::Mash.new
      
      ["small", "medium", "large", "extralarge", "mega"].each do |size|
        result.send("#{size}=", image(xml, xpath, size))
      end
      
      result
    end
    
    def image(xml, xpath, size)
      xml.at("#{xpath}[@size='#{size}']").content rescue nil
    end
  end
end
