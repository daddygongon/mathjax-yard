require "mathjax-yard/version"
require "mathjax-yard/script"
require "mathjax-yard/init"
require 'optparse'
require 'yaml'
require 'fileutils'
require 'systemu'

module MathJaxYard
  class Command
    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @eq_data=Hash.new
      @eq_number =0
      @revert = false
    end

    def execute
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Yardmath::VERSION
          puts opt.ver
          exit
        }
        opt.on('-r', '--revert','revert mjx file to orig file.') {
          directory = @argv[0]==nil ? 'lib/../*' : @argv[0]
          revert(directory)
          exit
        }
        opt.on('-p', '--pre','pre operation.') {
          directory = @argv[0]==nil ? 'lib/../*' : @argv[0]
          convert(directory)
          exit
        }
        opt.on('--post','post operation.') {
          post_operation
          directory = @argv[0]==nil ? 'lib/../*' : @argv[0]
          revert(directory)
          exit
        }
        opt.on('-i', '--init','init for mathjax on yard layout.') {
          init_yard()
          exit
        }
      end
      command_parser.banner = <<EOF 
Usage: mathjax-yard [options] [DIRECTORY]
with no extention: mathjax-yard -p lib/../*/*.md

EOF
      command_parser.parse!(@argv)
      directory = @argv[0]==nil ? 'lib/../*' : @argv[0]
      convert(directory)
      exit
    end

    def post_operation
      src = File.read("./mathjax.yml")
      p data = YAML.load(src)
      data.each_pair{|file, tags|
        File.basename(file).scan(/(.+)\.md/)
        p basename = $1
        target = "./doc/file.#{basename}.html"
        src = File.read(target)
        tags.each_pair{|tag,eq|
          src.gsub!(tag,eq)
        }
        File.write(target,src)
      }
    end


#    BACKUP_FILE_EXT ='*.md.back'
#    RE_BACKUP_FILE_EXT ='(.+).back$'
    BACKUP_FILE_EXT ='*.mjx.md'
    RE_BACKUP_FILE_EXT ='(.+).mjx.md$'
    def revert(directory)
      files = Dir.glob(File.join(directory,BACKUP_FILE_EXT))
      files.each{|b_file|
        b_file.scan(Regexp.new(RE_BACKUP_FILE_EXT))
        p t_file = $1+'.md'
#        p t_file = $1
        FileUtils.mv(b_file,t_file)
      }
    end

    def convert(directory)
#      revert(directory)
      files = Dir.glob(File.join(directory,'*.md'))
      files.each{|base_file|
        file = mk_backup_file_name(base_file)
        @eq_data[file] = Hash.new
        lines = File.readlines(base_file)
        output = mk_tags(lines,file)
        if @eq_data[file].size ==0
          @eq_data.delete(file)
        else
          write_output_on_target(base_file,output)
        end
      }
      File.write("mathjax.yml",YAML.dump(@eq_data))
    end

    def mk_backup_file_name(file)
      dir=File.dirname(file)
      File.basename(file).scan(/(.*).md/)
      basename=$1
      return File.join(dir,"#{basename}.mjx.md")
#      return file+'.back'
    end

    def write_output_on_target(file,output)
      b_file = mk_backup_file_name(file)
      FileUtils.mv(file,b_file)
      File.write(file,output)
    end

    def mk_tags(lines,file_name)
      @in_eq_block = false
      output,stored_eq="",""
      lines.each{|line|
        if @in_eq_block #inside in eq block
          if line =~/^\$\$/ #closing
            stored_eq << "$"
            output << store_eq_data("$#{stored_eq}$",file_name)
            stored_eq=""
            @in_eq_block = !@in_eq_block
          else #normal op. in eq block
            p stored_eq << line
          end
        else #outside eq block
          case line
          when /\\\$(.*?)\\\$/
            p line
            output << line # tryed to change $$ but failed.
          when /\$(.+?)\$/
            p line
            line.gsub!(/\$(.+?)\$/){|equation|
              store_eq_data(equation,file_name)
            }
            output << line
          when /^\$\$/ # opening in eq block
            @in_eq_block = !@in_eq_block
            stored_eq << "$"
          else  #normal op (no eq)
            output << line
          end
        end
      }
      return output
    end

    def store_eq_data(equation,file_name)
      @eq_number+=1
      tag="$MATHJAX#{@eq_number}$"
      @eq_data[file_name][tag] = equation
      return tag
    end
  end
end

