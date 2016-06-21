require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "make documents by yard"
task :yard do
  system('mathjax-yard')
  YARD::Rake::YardocTask.new
end

desc "make documents with yardmath"
task :mathjax do
  system('mathjax-yard --post')
end
