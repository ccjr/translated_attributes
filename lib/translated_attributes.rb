# TranslatedAttributes
module Spinbits
  module TranslatedAttributes #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def translated_attributes(options = {})
        include Spinbits::TranslatedAttributes::InstanceMethods
      end
    end
    
    # This module contains instance methods
    module InstanceMethods
      # This makes calling ".name" lookup ".name_en" or ".name_ar" depending on the locale
      def method_missing(meth, *args)
        if self.respond_to? "#{meth.to_s}_#{I18n.locale}"
          send("#{meth.to_s}_#{I18n.locale}")
        else
          super meth, *args
        end
      end
    end
    
  end
end