module ProfanityFilter
  def self.included(base)
    # base.send :extend, ClassMethods
      base.class_eval do
        extend ClassMethods
      end

  end

  module ClassMethods
    def profanity_filter!(*attr_names)
      option = attr_names.pop[:method] if attr_names.last.is_a?(Hash)
      attr_names.each { |attr_name| setup_callbacks_for(attr_name, option) }
    end

    def profanity_filter(*attr_names)
      option = attr_names.pop[:method] if attr_names.last.is_a?(Hash)

      attr_names.each do |attr_name|
        instance_eval do
          define_method "#{attr_name}_clean" do; ProfanityFilter::Base.clean(self[attr_name.to_sym], option); end
          define_method "#{attr_name}_original" do; self[attr_name]; end
          define_method "profanity_filtered_attrs" do; attr_names; end
          alias_method attr_name.to_sym, "#{attr_name}_clean".to_sym
          
          define_method "unbind_profanity" do
            profanity_filtered_attrs.each do |attr_name|
              eval %(
                class << self
                  undef_method :#{attr_name}
                  def #{attr_name}
                    @attributes[%q(#{attr_name})]
                  end
                end
              )
            end
          end
          define_method "bind_profanity" do
            profanity_filtered_attrs.each do |attr_name|
              eval %(
                class << self
                  undef_method :#{attr_name}
                  alias_method :#{attr_name}, :#{attr_name}_clean
                end
              )
            end
          end
          
          #Before and after save does not get triggered until after the attributes have been accessed.
          #SO... lets override the save method.
          define_method "save" do |*args|
            unbind_profanity
            super(*args)
            bind_profanity
          end
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
    cattr_accessor :replacement_text, :dictionary_file, :dictionary
    @@replacement_text = '@#$%'
    @@dictionary_file  = File.join(File.dirname(__FILE__), '../config/dictionary.yml')

    class << self
      def dictionary
        @@dictionary ||= YAML.load_file(@@dictionary_file)
      end
      
      def append_dictionary( file )
        @@dictionary = dictionary.merge(YAML.load_file( file ) )
      end
      
      def remove_from_dictionary( file )
        excluded_words = YAML.load_file( file )
        if excluded_words
          dictionary.keep_if do |dictionary_word|
            !( excluded_words.include?(dictionary_word) )
          end
        end
      end
      
      def banned?(word = '')
        dictionary.include?(word.downcase) if word
      end

      def profane?(text = '')
        text == clean(text) ? false : true
      end

      def clean(text, replace_method = '')
        return text if text.blank?
        @replace_method = replace_method
        text.split(/(\s)/).collect{ |word| clean_word(word) }.join
      end

      def clean_word(word)
         return word unless(word.strip.size > 2)

         if word.index(/[\W]/)
           word = word.split(/(\W)/).collect{ |subword| clean_word(subword) }.join
           concat = word.gsub(/\W/, '')
           word = concat if banned? concat
         end

         banned?(word) ? replacement(word) : word
       end

       def replacement(word)
         case @replace_method
         when 'dictionary'
           dictionary[word.downcase] || word
         when 'vowels'
           word.gsub(/[aeiou]/i, '*')
         when 'hollow'
           word[1..word.size-2] = '*' * (word.size-2) if word.size > 2
           word
         when 'stars'
           word = '*' * (word.size)
         else
           replacement_text
         end
       end
    end
  end
end

ActiveRecord::Base.send(:include, ProfanityFilter) if defined?(ActiveRecord)
