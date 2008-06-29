require "benchmark"

module ProfanityFilter
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def profanity_filter!(*attr_names)
      option = attr_names.pop[:method] rescue nil if attr_names.last.is_a?(Hash)
      attr_names.each { |attr_name| setup_callbacks_for(attr_name, option) }
    end
    
    def profanity_filter(*attr_names)
      option = attr_names.pop[:method] rescue nil if attr_names.last.is_a?(Hash)

      attr_names.each do |attr_name| 
        instance_eval do
          define_method "#{attr_name}_clean" do; ProfanityFilter::Base.clean(self[attr_name.to_sym], option); end      
          define_method "#{attr_name}_original"do; self[attr_name]; end
          alias_method attr_name.to_sym, "#{attr_name}_clean".to_sym
        end
      end
    end
    
    def setup_callbacks_for(attr_name, option)
      before_validation do |record|
        record[attr_name.to_sym] = ProfanityFilter::Base.clean(record[attr_name.to_sym], option)
      end
    end
  end
  
  class Base
    DICTIONARY = YAML.load_file(File.join(File.dirname(__FILE__), '../config/dictionary.yml'))

    def self.clean(text, replace_method = '')
      return text if text.blank?
      text.split(/(\W)/).collect{|word| replace_method == 'dictionary' ? clean_word_dictionary(word) : clean_word_basic(word)}.join
    end

    def self.clean_word_dictionary(word)
      DICTIONARY.include?(word.downcase.squeeze) && word.size > 2 ? DICTIONARY[word.downcase.squeeze] : word
    end

    def self.clean_word_basic(word)
      DICTIONARY.include?(word.downcase.squeeze) && word.size > 2 ? '@#$%' : word
    end
  end
end
