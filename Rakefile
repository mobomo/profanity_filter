require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

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