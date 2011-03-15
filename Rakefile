require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "profanity_filter"
  gem.homepage = "http://github.com/intridea/profanity_filter"
  gem.license = "MIT"
  gem.summary = %Q{A Rails plugin gem for filtering out profanity.}
  gem.description = %Q{Allows you to filter profanity using basic replacement or a dictionary term.}
  gem.email = "adambair@gmail.com"
  gem.authors = ["Adam Bair"]
end
Jeweler::RubygemsDotOrgTasks.new

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the Profanity Filter plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the happy plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Profanity Filter'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Measures test coverage using rcov'
task :rcov do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
  system("#{rcov} --html #{Dir.glob('test/**/*_test.rb').join(' ')}")
  system("open coverage/index.html") if PLATFORM['darwin']
end
