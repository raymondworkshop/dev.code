# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1). remove the last columns for each file
#     2). 
#     3). truncate half part for each file

#data dir
dtdir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/data/"
# source dir
source = dtdir + "source/"
# target dir
target = dtdir + "target/"

Dir.glob(source + "*.txt") do | file |
   #for each file
   puts "working on: #{file} ..."
   #record the number of minutiae point in each file
   minunum = 0
   skip1 = 50
   skip2 = 50
   skip3 = 50
   halfminu = 0
   i = 0
   
   File.open(target + File.basename(file), 'w')  do | f |
       
       File.open(file).readlines.collect do | line |
           #for each 
           #skip the "*_1.txt" file
           if /_1.txt/ =~ File.basename(file)
               #puts "skip #{file} ..."
           else
               #puts "working on: #{file} ..."
               #store the line num
               i += 1 
               if i == 4
                   #the num
                   minunum = line.chomp
                   #puts minunum
                   halfminu = minunum.to_i / 2
                   
                   #The ending line of the first half part
                   #skip1 = halfminu + 4
                   #The boundary between the data and the 'True'
                   # + 1 is the 2nd count
                   #skip2 = minunum.to_i + 4 + 1 
                   #THe ending line of the first half part of 'True'
                   #skip the 'True
                   #skip3 = halfminu + skip2
                   
                   skip1 = halfminu + 4;
                   skip2 = minunum.to_i + 4 + 1 
                   skip3 = halfminu + skip2
                   
                   #puts skip1
                   #puts skip2
                   #puts skip3
              
                   line = minunum.to_i - halfminu
               end
               
               
               #if i > skip1
               #   if i < skip2
               #      next
               #   end
               #end
               
               if (i > 4) and (i <= skip1)
                   next
               end
           
               if i == skip2
                  line = minunum.to_i - halfminu
               end
             
               #if i > skip3
               #   next
               #end
               
               if (i > skip2 ) and (i <= skip3)
                   next
               end
               
          end 
          
          #puts line
          f.puts line
          
       end  
   
   f.close()

   end 
   
end
