require 'test/unit'
require 'rubygems'
require 'yaml'
require 'activerecord'

require File.dirname(__FILE__) + '/../lib/profanity_filter'

module DictionaryHelper
  def assert_replacement(word, replacement)
    assert_equal '@#$%', ProfanityFilter::Base.clean(word)
    assert_equal replacement, ProfanityFilter::Base.clean(word, 'dictionary')
  end
end

class DictionaryTest < Test::Unit::TestCase
  include DictionaryHelper
  
  def test_filter_should_replace_the_word_pussy_and_related
    assert_replacement('pussy', 'p*ssy')
    assert_replacement('pusys', 'p*ssys')
    assert_replacement('pussies', 'p*ss**s')
  end
end
