require 'test/unit'
require 'yaml'

begin
  require File.dirname(__FILE__) + '/../../../../config/environment'
rescue LoadError
  require 'rubygems'
  gem 'activerecord'
  gem 'actionpack'
  require 'active_record'
  require 'action_controller'
end

require File.dirname(__FILE__) + '/../lib/profanity_filter'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection('test')
load(File.dirname(__FILE__) + "/schema.rb")

ActiveRecord::Base.send(:include, ProfanityFilter)

