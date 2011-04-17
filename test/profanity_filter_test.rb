require 'test/unit'
require 'rubygems'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/profanity_filter'

class BasicProfanityFilterTest < Test::Unit::TestCase
  def test_basic_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy')
  end
  
  def test_basic_profanity_filter_does_not_modify_whitespace
    assert_equal 'hello  world', ProfanityFilter::Base.clean('hello  world')
    assert_equal "hello \t world", ProfanityFilter::Base.clean("hello \t world")
    assert_equal "hello \n world", ProfanityFilter::Base.clean("hello \n world")
  end
  
  def test_basic_profanity_filter_does_not_modify_special_characters
    assert_equal 'happy  @#$%', ProfanityFilter::Base.clean('happy  fuck')
    assert_equal 'happy\'s', ProfanityFilter::Base.clean('happy\'s')
    assert_equal '@#$%\'s', ProfanityFilter::Base.clean('fuck\'s')
    assert_equal '@#$%?!', ProfanityFilter::Base.clean('fuck?!')
  end
  
  def test_basic_profanity_filter_replaces_profane_words
    assert_equal '@#$%', ProfanityFilter::Base.clean('fuck')
  end
  
  def test_basic_profanity_filter_replaces_punctuation_spaced_profane_words
    assert_equal '@#$%', ProfanityFilter::Base.clean('f-u-c-k')
    assert_equal '@#$%', ProfanityFilter::Base.clean('f.u.c.k')
    assert_equal 'happy-@#$%', ProfanityFilter::Base.clean('happy-fuck')
  end
  
  def test_knows_when_text_is_not_profane
    assert !ProfanityFilter::Base.profane?('happy')
  end

  def test_knows_when_text_is_profane
    assert ProfanityFilter::Base.profane?('fuck')
  end

  # Issue #1 https://github.com/intridea/profanity_filter/issues/1 
  def test_knows_when_text_contains_profanity
    assert ProfanityFilter::Base.profane?('oh shit')
  end

  def test_knows_nil_is_not_profane
    assert !ProfanityFilter::Base.profane?(nil)
  end
end

class DictionaryProfanityFilterTest < Test::Unit::TestCase
  def test_dictionary_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy', 'dictionary')
  end
  
  def test_dictionary_profanity_filter_does_not_modify_whitespace
    assert_equal 'hello  world', ProfanityFilter::Base.clean('hello  world', 'dictionary')
    assert_equal "hello \t world", ProfanityFilter::Base.clean("hello \t world", 'dictionary')
    assert_equal "hello \n world", ProfanityFilter::Base.clean("hello \n world", 'dictionary')
  end
  
  def test_dictionary_profanity_filter_does_not_modify_special_characters
    assert_equal 'happy  f*ck', ProfanityFilter::Base.clean('happy  fuck', 'dictionary')
    assert_equal 'happy\'s', ProfanityFilter::Base.clean('happy\'s', 'dictionary')
    assert_equal 'f*ck\'s', ProfanityFilter::Base.clean('fuck\'s', 'dictionary')
    assert_equal 'f*ck?!', ProfanityFilter::Base.clean('fuck?!', 'dictionary')
  end 
  
  def test_dictionary_profanity_filter_replaces_profane_words
    assert_equal 'f*ck', ProfanityFilter::Base.clean('fuck', 'dictionary')
  end
  
  def test_dictionary_profanity_filter_replaces_punctuation_spaced_profane_words
    assert_equal 'f*ck', ProfanityFilter::Base.clean('f-u-c-k', 'dictionary')
    assert_equal 'f*ck', ProfanityFilter::Base.clean('f.u.c.k', 'dictionary')
    assert_equal 'happy-f*ck', ProfanityFilter::Base.clean('happy-fuck', 'dictionary')
  end
end


class VowelsProfanityFilterTest < Test::Unit::TestCase
  def test_vowels_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy', 'vowels')
  end
  
  def test_vowels_profanity_filter_does_not_modify_whitespace
    assert_equal 'hello  world', ProfanityFilter::Base.clean('hello  world', 'vowels')
    assert_equal "hello \t world", ProfanityFilter::Base.clean("hello \t world", 'vowels')
    assert_equal "hello \n world", ProfanityFilter::Base.clean("hello \n world", 'vowels')
  end
  
  def test_vowels_profanity_filter_does_not_modify_special_characters
    assert_equal 'happy  f*ck', ProfanityFilter::Base.clean('happy  fuck', 'vowels')
    assert_equal 'happy\'s', ProfanityFilter::Base.clean('happy\'s', 'vowels')
    assert_equal 'f*ck\'s', ProfanityFilter::Base.clean('fuck\'s', 'vowels')
    assert_equal 'f*ck?!', ProfanityFilter::Base.clean('fuck?!', 'vowels')
  end
  
  def test_vowels_profanity_filter_replaces_profane_words
    assert_equal 'f*ck', ProfanityFilter::Base.clean('fuck', 'vowels')
    assert_equal 'F*CK', ProfanityFilter::Base.clean('FUCK', 'vowels')
  end
  
  def test_vowels_profanity_filter_replaces_punctuation_spaced_profane_words
    assert_equal 'f*ck', ProfanityFilter::Base.clean('f-u-c-k', 'vowels')
    assert_equal 'f*ck', ProfanityFilter::Base.clean('f.u.c.k', 'vowels')
    assert_equal 'happy-f*ck', ProfanityFilter::Base.clean('happy-fuck', 'vowels')
  end
end

class HollowProfanityFilterTest < Test::Unit::TestCase
  def test_hollow_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy', 'hollow')
  end
  
  def test_hollow_profanity_filter_does_not_modify_whitespace
    assert_equal 'hello  world', ProfanityFilter::Base.clean('hello  world', 'hollow')
    assert_equal "hello \t world", ProfanityFilter::Base.clean("hello \t world", 'hollow')
    assert_equal "hello \n world", ProfanityFilter::Base.clean("hello \n world", 'hollow')
  end
  
  def test_hollow_profanity_filter_does_not_modify_special_characters
    assert_equal 'happy  f**k', ProfanityFilter::Base.clean('happy  fuck', 'hollow')
    assert_equal 'happy\'s', ProfanityFilter::Base.clean('happy\'s', 'hollow')
    assert_equal 'f**k\'s', ProfanityFilter::Base.clean('fuck\'s', 'hollow')
    assert_equal 'f**k?!', ProfanityFilter::Base.clean('fuck?!', 'hollow')
  end
  
  def test_hollow_profanity_filter_replaces_profane_words
    assert_equal 'f**k', ProfanityFilter::Base.clean('fuck', 'hollow')
    assert_equal 'F**K', ProfanityFilter::Base.clean('FUCK', 'hollow')
  end
  
  def test_hollow_profanity_filter_replaces_punctuation_spaced_profane_words
    assert_equal 'f**k', ProfanityFilter::Base.clean('f-u-c-k', 'hollow')
    assert_equal 'f**k', ProfanityFilter::Base.clean('f.u.c.k', 'hollow')
    assert_equal 'happy-f**k', ProfanityFilter::Base.clean('happy-fuck', 'hollow')
  end
end

class StarsProfanityFilterTest < Test::Unit::TestCase
  def test_stars_profanity_filter_does_not_modify_clean_words
    assert_equal 'happy', ProfanityFilter::Base.clean('happy', 'stars')
  end
  
  def test_stars_profanity_filter_does_not_modify_whitespace
    assert_equal 'hello  world', ProfanityFilter::Base.clean('hello  world', 'stars')
    assert_equal "hello \t world", ProfanityFilter::Base.clean("hello \t world", 'stars')
    assert_equal "hello \n world", ProfanityFilter::Base.clean("hello \n world", 'stars')
  end
  
  def test_stars_profanity_filter_does_not_modify_special_characters
    assert_equal 'happy  ****', ProfanityFilter::Base.clean('happy  fuck', 'stars')
    assert_equal 'happy\'s', ProfanityFilter::Base.clean('happy\'s', 'stars')
    assert_equal '****\'s', ProfanityFilter::Base.clean('fuck\'s', 'stars')
    assert_equal '****?!', ProfanityFilter::Base.clean('fuck?!', 'stars')
  end
  
  def test_stars_profanity_filter_replaces_profane_words
    assert_equal '****', ProfanityFilter::Base.clean('fuck', 'stars')
    assert_equal '****', ProfanityFilter::Base.clean('FUCK', 'stars')
  end
  
  def test_stars_profanity_filter_replaces_punctuation_spaced_profane_words
    assert_equal '****', ProfanityFilter::Base.clean('f-u-c-k', 'stars')
    assert_equal '****', ProfanityFilter::Base.clean('f.u.c.k', 'stars')
    assert_equal 'happy-****', ProfanityFilter::Base.clean('happy-fuck', 'stars')
  end
end
