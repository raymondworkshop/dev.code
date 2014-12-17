# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1). remove the last columns for each file
#

#target dir
dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/target/"

Dir.glob("/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/*.txt") do | file | 
   #for each file
   puts "working on: #{file}..."
   
   File.open(dir + File.basename(file), 'w') do | f |

       File.open(file).readlines.collect do | line |
           #for each line
           puts "working on: #{line}"
           arr = line.chomp.split

           #remove the last two column
           arr.delete_at(13)
           arr.delete_at(13)

           #write to target file           
           f.puts arr.join(" ") + "\n"
       end

   f.close()

   end
end
