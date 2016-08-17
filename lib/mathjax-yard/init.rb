module MathJaxYard
  class Command
    def init_yard()
      target_dir=get_yard_layout_dir()
      FileUtils.cd(target_dir){
        tmp_dir='mathjax' # 'math2'
        full_path="#{target_dir}/#{tmp_dir}/layout/html/layout.erb"
        if File.exist?("#{tmp_dir}/layout/html/layout.erb")
          print("file #{full_path} exists.\nDelete them first.\n")
          return
        end
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
      src=File.read(file_name)
      src.gsub!(ORIGINAL,MATH_SCRIPT+ORIGINAL)
      File.write(file_name,src)
    end
  end
end
