require 'test/unit'
require 'rubygems'
require 'yaml'
require 'activerecord'

require File.dirname(__FILE__) + '/../lib/profanity_filter'

class BasicProfanityFilterTest < Test::Unit::TestCase
  def test_basic_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy')
  end
  
  def test_basic_profanity_filter_replaces_profane_words
    assert_equal '@#$%', ProfanityFilter::Base.clean('fuck')
  end
end

class DictionaryProfanityFilterTest < Test::Unit::TestCase
  def test_dictionary_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy', 'dictionary')
  end
  
  def test_dictionary_profanity_filter_replaces_profane_words
    assert_equal 'f*ck', ProfanityFilter::Base.clean('fuck', 'dictionary')
  end
end