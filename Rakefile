# encoding: utf-8

# Process of development:
#   1. do the actual coding and update (hopfully with tests)
#   2. commit
#   3. goto 1 if needed :) else goto 4
#   4. update the version in lib/flushing-flash/version.rb
#   5. git commit -am "bump version to 0.1.0" # please update the version number
#   6. rake install to install locally (and hopfully test it with test applications)
#   7. rake release

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/flushing-flash/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "flushing-flash"
  gem.homepage = "http://github.com/peterwongpp/flushing-flash"
  gem.license = "MIT"
  gem.summary = "To provide helper methods for handling rails flash messages."
  gem.description = "To provide helper methods for handling rails flash messages."
  gem.email = "peter@peterwongpp.com"
  gem.authors = ["PeterWong"]
  gem.version = FlushingFlash::Version::STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "flushing-flash #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
