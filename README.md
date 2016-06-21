# MathJaxYard

mathjax-yard is a mathjax extention for markdown in yard.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mathjax-yard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mathjax-yard

## Usage

mathjax-yard is intended to be a command line tool, using in Rakefile as follows.

'''

desc "make documents by yard"
task :yard do
  system('mathjax-yard')
  YARD::Rake::YardocTask.new
end

desc "make documents with yardmath"
task :mathjax do
  system('mathjax-yard --post')
end
'''
mathjax-yard search ./*/*.md and replace '$...$' or '$$...$$' to $MATHJAX**$ tags, and make 'mathjax.yml' for storing these relations.  After the normal YARD operation has done, 'mathjax-yard --post' replacement will be done on 'doc/file.*.hmtl'.  The yard options are

'''
-t mathjax -p templates
-
spec/*.md
'''

The mathjax layout should be included in yard layour.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec mathjax-yard` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mathjax-yard. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

