module LastFM
  module ImageReader
    def self.images(xml, xpath, options={})
      result = Hashie::Mash.new
      
      ["original", "small", "medium", "large", "largesquare", "extralarge", "mega"].each do |size|
        image = image(xml, xpath, size, options)
        result.send("#{size}=", image) if image
      end
      
      result
    end
    
    def self.image(xml, xpath, size, options)
      attribute_name = options[:size_attribute] || "size"
      xml.at("#{xpath}[@#{attribute_name}='#{size}']").content rescue nil
    end
  end
end
