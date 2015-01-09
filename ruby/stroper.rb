# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1). remove the last columns for each file
#

#target dir
#dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/target/"
dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/2order"
target = dir + "1.txt"
source = dir + "1_0.01.txt"
   
File.open(source, 'r').readlines.collect do | line |
   #for each line
   puts "working on: #{line}"  
   
end


