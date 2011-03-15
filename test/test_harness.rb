require 'rubygems'
require 'test/unit'
require 'yaml'
require 'active_record'
require 'active_support/all'

require File.dirname(__FILE__) + '/../lib/profanity_filter'
require File.dirname(__FILE__) + '/connection_and_schema'

ActiveRecord::Base.send(:include, ProfanityFilter)

