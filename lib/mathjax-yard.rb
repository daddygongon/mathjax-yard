require "mathjax-yard/version"
require "mathjax-yard/script"
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
          directory = @argv[0]==nil ? 'lib/../*/*.md.back' : @argv[0]
          revert(directory)
          exit
        }
        opt.on('-p', '--post','post operation.') {
          post_operation
          directory = @argv[0]==nil ? 'lib/../*/*.md.back' : @argv[0]
          revert(directory)
          exit
        }
        opt.on('-i', '--init','initiation for mathjax extension on yard layout.') {
          init_yard()
          exit
        }
      end
      command_parser.banner = "Usage: yardmath [options] [DIRECTORY]"
      command_parser.parse!(@argv)
      directory = @argv[0]==nil ? 'lib/../*/*.md' : @argv[0]
      convert(directory)
      exit
    end

    def init_yard()
      target_dir=get_yard_layout_dir()
      FileUtils.cd(target_dir){
        tmp_dir='mathjax' # 'math2'
        FileUtils.cp_r('default',tmp_dir)
        modify_layout("#{tmp_dir}/layout/html/layout.erb")
        modify_layout("#{tmp_dir}/onefile/html/layout.erb")
      }
    end

    def get_yard_layout_dir()
      status, stdout, stderr  = systemu('gem env | grep INSTALLATION ')
      p inst_dir= stdout.split("\n")[0].split(': ')[1]
      status, stdout, stderr  = systemu('yard -v')
      p yard_num= stdout.split(' ')[0]+'-'+stdout.split(' ')[1]
      p target_dir = File.join(inst_dir,'gems',yard_num,"templates")
      return target_dir
    end

    def modify_layout(file_name)
      p file_name
      src=Ffile.read(file_name)
      src.gsub!(ORIGINAL,MATH_SCRIPT+ORIGINAL)
      File.write(file_name,src)
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

    def revert(directory)
      files = Dir.glob(directory)
      files.each{|b_file|
        b_file.scan(/(.+).back$/)
        p t_file = $1
        FileUtils.mv(b_file,t_file)
      }
    end

    def convert(directory)
      files = Dir.glob(directory)
      files.each{|file|
        @eq_data[file] = Hash.new
        lines = File.readlines(file)
        output = mk_tags(lines,file)
        if @eq_data[file].size ==0
          @eq_data.delete(file) 
        else
          write_output_on_target(file,output)
        end
      }
      File.write("mathjax.yml",YAML.dump(@eq_data))
    end

    def write_output_on_target(file,output)
      b_file = file+'.back'
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

