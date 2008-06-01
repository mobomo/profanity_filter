require 'test/unit'
require 'yaml'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require_gem 'activerecord'
end

require File.dirname(__FILE__) + '/../lib/profanity_filter'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])
load(File.dirname(__FILE__) + "/schema.rb")
ActiveRecord::Base.send(:include, ProfanityFilter)