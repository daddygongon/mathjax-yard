# MathJaxYard

mathjax-yardはyardによるmarkdown変換においてmathjaxを使えるようにする拡張機能です．

Github, rubygemsなど，この文書をどのサイトで見るかによって見え方が変わります．

- [yardの出力見本](http://nishitani0.kwansei.ac.jp/Open/mathjax-yard/)

が，mathjax-yardで意図している完成形です．そこから数式サンプルをたどってみてください．綺麗に数式が表示されるはず．

- [なぜ開発したか](file.Why_mathjax-yard.mjx.html)
- [数式サンプル1](file.atom.mjx.html)
- [数式サンプル2](file.potential.mjx.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mathjax-yard'
```
or
```ruby
Gem::Specification.new do |spec|
...
  spec.add_development_dependency "mathjax-yard", "~> 1.0.2"
end
```
And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install mathjax-yard
```

## Usage
mathjax-yardは，bundle gemで作られるgemの開発directoryでの文書作成を前提に作られています．

### 準備
yardのoptionは，.yardoptsに

```
-t mathjax -p templates
-
spec/*.md
```

としています．

htmlのhead部分にmathjaxのscriptを埋め込んだlayoutを用意する必要があります．
mathjax-yardでは，
```csh
 mathjax-yard --init
```
で自動生成します．

### Rakefileでの使用例

Rakefileでの使用例は次の通りです．

```ruby
desc "make documents by yard"
task :yard do
  YARD::Rake::YardocTask.new
end

desc "arrange yard target by mathjax-yard"
task :pre_math do
  system('mathjax-yard')
end

desc "make yard documents with yardmath"
task :myard => [:pre_math,:yard] do
  system('mathjax-yard --post')
end
```

yardのデフォルトでの動作をなぞって，動作するように作られています．
- mathjax-yardは./*/*.mdを探索し，それらの中に'\$\$'あるいは'\$\$..\$\$'があると\$MATHJAX20\$などというタグに付け替え，
- *.mjx.mdとしたファイルに元ファイルのバックアップを取り，タグ付け替えした内容を保存します．
- また，同時に，'mathjax.yml'にそれらのhash関係をyaml形式で保存します．
- 通常のrake yardで変換したのち，
- 'mathjax-yard --post'によって，'doc/file.*.mjx.html'に残されたtagを元に戻します．
- また同時に，mjx.mdファイルを消します．
- doc中には，files.*.mjx.htmlとfiles.*.htmlという2種類のほぼ同じ内容のhtmlが生成されます．

```csh
bob% mathjax-yard --help
Usage: yardmath [options] [DIRECTORY]
    -v, --version                    show program Version.
    -r, --revert                     revert mjx file to orig file.
    -p, --post                       post operation.
    -i, --init                       initiation for mathjax extension on yard layout.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec mathjax-yard` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## left issues
- [残された課題](file.left_issue.html)

## Contributing

Bug reports and pull requests are welcome on GitHub at [[https://github.com/[USERNAME]/mathjax-yard]]. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
