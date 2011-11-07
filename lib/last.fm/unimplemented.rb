module LastFM
  module Unimplemented

    def self.included(base)
      base.extend ClassMethods
    end
      
    module ClassMethods
      def unimplemented(options)
        options[:methods].each do |unimplemented_method|
          define_method(unimplemented_method) do
            raise "Instance method #{unimplemented_method} is not yet implemented"
          end
          
          self.singleton_class.class_eval do
            define_method(unimplemented_method) do
              raise "Class method #{unimplemented_method} is not yet implemented"
            end
          end
        end
      end
    end
  end
end