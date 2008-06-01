module ProfanityFilter
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def profanity_filter!(*attr_names)
      option = attr_names.pop[:method] rescue nil if attr_names.last.is_a?(Hash)
      attr_names.each { |attr_name| setup_callbacks_for(attr_name, option) }
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
      text.split(/(\W)/).collect{|word| replace_method == 'dictionary' ? clean_word_dictionary(word) : clean_word_basic(word)}.join
    end

    def self.clean_word_dictionary(word)
      DICTIONARY.keys.include?(word.downcase.squeeze) && word.size > 2 ? DICTIONARY[word.downcase.squeeze] : word
    end

    def self.clean_word_basic(word)
      DICTIONARY.keys.include?(word.downcase.squeeze) && word.size > 2 ? '@#$%' : word
    end
  end
end
