require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'
p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "make documents by yard"
task :yard do
  YARD::Rake::YardocTask.new
end

desc "make md documents from hiki"
task :hiki2md do
  files = Dir.entries('docs')
  files.each{|file|
    name=file.split('.')
    if name[1]=='hiki' then
      p command="hiki2md docs/#{name[0]}.hiki > #{basename}.wiki/#{name[0]}.md"
      system command
    end
  }
  system "cp #{basename}.wiki/README_ja.md README.md"
  system "cp #{basename}.wiki/README_ja.md #{basename}.wiki/Home.md"
  system "cp docs/*.gif #{basename}.wiki"
  system "cp docs/*.gif doc"
  system "cp docs/*.png #{basename}.wiki"
  system "cp docs/*.png doc"
end

desc "arrange yard target by mathjax-yard"
task :pre_math do
  system('mathjax-yard')
end

desc "make yard documents with yardmath"
task :myard => [:hiki2md, :pre_math,:yard] do
  system('mathjax-yard --post')
end
