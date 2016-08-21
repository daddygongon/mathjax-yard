require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'
require 'fileutils'

p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "make documents by yard"
task :yard do
#  YARD::Rake::YardocTask.new
  YARD::Rake::YardocTask.new{|t|
#    t.files=['lib/**/*.rb','**/*.md']
#    t.options=['-t','mathjax']
  }

  YARD::Rake::YardocTask.new {|t|
#    t.files=['**/*.md']
#    t.options=['-t','mathjax']
    t.options=['--exclude','lib/**/*.rb','--files','**/*.md','-t','mathjax']
  }

end

task :hiki2md do
  files = Dir.entries('hikis')
  FileUtils.mkdir_p("#{basename}.wiki")
  files.each{|file|
    name=file.split('.')
    if name[1]=='hiki' then
      p command="hiki2md hikis/#{name[0]}.hiki > #{basename}.wiki/#{name[0]}.md"
      system command
    end
  }
  begin
    FileUtils.cp("#{basename}.wiki/README_ja.md", "README.md")
    FileUtils.cp("#{basename}.wiki/README_ja.md","#{basename}.wiki/Home.md")
    FileUtils.cp("hikis/*.gif","#{basename}.wiki")
    FileUtils.cp("hikis/*.gif","doc")
    FileUtils.cp("hikis/*.png","#{basename}.wiki")
    FileUtils.cp("hikis/*.png","doc")
  rescue => ex
    puts "#{ex.class}"
  end
end

desc "arrange yard target by mathjax-yard"
task :pre_math do
  system('mathjax-yard')
end

desc "make yard documents with yardmath"
task :myard => [:hiki2md, :pre_math,:yard] do
  system('mathjax-yard --post')
end
