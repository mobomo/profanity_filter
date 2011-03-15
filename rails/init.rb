require 'profanity_filter'
ActiveRecord::Base.send(:include, ProfanityFilter)
