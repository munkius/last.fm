module LastFM
  class Album

    attr_reader :name, :artist, :images, :playcount, :rank, :url
    
    class << self
      def from_xml(xml)
        name = xml.at("./name").content
        
        options = {}
        options[:playcount] = xml.at("./playcount").content.to_i
        options[:url] = xml.at("./url").content
        options[:artist] = Hashie::Mash.new
          options[:artist].name = xml.at("./artist/name").content
          options[:artist].url = xml.at("./artist/url").content
        
        options[:images] = ImageReader::images(xml, "./image")
        
        yield(xml, options) if block_given?
        
        self.new(name, options)
      end
      
    end
    
  private
  
    def initialize(name, options)
      @name = name
      
      options = options.dup
      @artist, @images, @playcount, @rank, @url =
        options.delete(:artist), options.delete(:images), options.delete(:playcount), options.delete(:rank), options.delete(:url)
      
      raise "Invalid options passed: #{options.keys.join(", ")}" if options.keys.size > 0
    end
  end
end