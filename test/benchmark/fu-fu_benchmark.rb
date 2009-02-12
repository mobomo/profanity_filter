#!/usr/bin/env ruby -wKU

require 'yaml'
require 'benchmark'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_support'
rescue LoadError
  require 'rubygems'
  require 'active_support'
end

require File.join(File.dirname(__FILE__), '../../lib/profanity_filter')

def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

%w(100 1000 5000 25000 50000 100000).each do |dictionary_count|
  puts "\n#{dictionary_count} word dictionary-----"
  silently {ProfanityFilter::Base.dictionary = YAML.load_file(File.join(File.dirname(__FILE__), "dictionary_test_#{dictionary_count}.yml"))}
  %w(100 1000 5000 10000).each do |word_count|
    puts "\n  --#{word_count} words string-----"
    text = ''
    File.open("text_test_#{word_count}.txt", "r") { |f| text = f.read }
    
    puts '  Run a single time'
    puts Benchmark.measure {ProfanityFilter::Base.clean(text)}
    
    n = 50
    puts "  Run #{n} times"
    Benchmark.bm do |x|
      x.report { 1.upto(n) do ; ProfanityFilter::Base.clean(text); end }
    end
  end
end

# ProfanityFilter::Base.clean('fucker')
