# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1). remove the last columns for each file
#

#target dir
#dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/2order/"
dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/data/"
#source = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/2order_/1_0.5.txt"
source = dir + "2.txt"
 
target = dir + "1_.txt"

#store the data
data = Array.new() 

File.open(target, 'w') do | f |
   File.open(source).readlines.collect do | line |
      #for each line
      puts "working on: #{line}"
      
      arr = line.chomp.split(";")
      #is the flag line
      if arr.include?("COMPRESS_THRELOD")
          arr_thre = Array.new()
          
          #threshold = line.split(";")
          puts  arr[1]
          
          #store each threshold
          arr_thre.push(arr[1])
          
          #put the array to global Array data
          data.push(arr_thre)
          
      else
          arr_thre = data.pop()
          #arr_thre.push(arr[0])
          arr_thre.push(arr[1])
          
          data.push(arr_thre)
          
      end 
      
       
  end
  
  #puts data.length()

  newdata = data.transpose
  puts newdata
  puts "---"
  
  $i = 0
  while $i < newdata.length() do
      
      #f.puts data.join(";") + "\n"
     
      #store the threshold value
      #threshold.push(data[$i][0])
      #data[$i][0].pop()
      
      puts newdata[$i].join(";")
      f.puts newdata[$i].join(";")
      $i += 1
  end
  
  f.close()
  
end
