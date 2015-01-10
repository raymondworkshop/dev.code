# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1) remove the last columns for each file
#     2)
#     3) re-arrange the file format  

#target dir
dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/"
#source = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/2order_/1_0.5.txt"
source = dir + "2order_0.05.txt"
 
target = dir + "1_.txt"

#GLOBAL ARRAY
#store the data
data = Array.new() 
#store the index
index = Array.new()

#store the num of the flag 'COMPRESS_THRESHOLD'
num = 0

File.open(target, 'w') do | f |
   File.open(source).readlines.collect do | line |
      #for each line
      #puts "working on: #{line}"

      arr = line.chomp.split(";")

      #is the flag line
      if arr.include?("COMPRESS_THRESHOLD")
          puts "working on: #{line}"
          arr_thre = Array.new()
          
          #store the threshold
          arr_thre.push(arr[1])
          
          #put the array to GLOBAL Array data
          data.push(arr_thre)

          #store the flag num
          num += 1
      else
          #get this Array arr_thre through GLOBAL Array data
          arr_thre = data.pop()  #this is the num like '0.01'
          
          #get the value
          arr_thre.push(arr[1])
          #store the value in data in ARRAY format
          data.push(arr_thre)

          #store the index once to meet the output format         
          if num == 1
              index.push(arr[0])
          end
          
      end 
       
  end
  
  #transpose data matrix  
  newdata = data.transpose
  #meet the output format
  index.insert(0,0)
  
  puts  
  puts "Give the output in #{target} ..."

  $i = 0
  while $i < newdata.length() do
      
      #store the threshold value
      #threshold.push(data[$i][0])
      #data[$i][0].pop()
      
      #puts newdata[$i].insert(0,index.shift()).join(";")
      f.puts newdata[$i].insert(0, index.shift()).join(";") + ";"
      $i += 1
  end
  
  f.close()
  
end
