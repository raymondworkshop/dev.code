# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1) remove the last columns for each file
#     2) combine the txt file content
# 
#   TODO: a lib to do this kind of string operations

#target dir
#dir = "E:\\wenlong\\cs\\mcc-lsh\\Geo-LSH\\Geo-LSH\\Geo-LSH-96-intersection_\\ScoreListUsingGeoHashing\\bin\\Debug\\output"
dir = "E:\\wenlong\\cs\\general\\MarkChainAnalyze\\MRF-EachSection-2order-intersection-6dim\\ScoreListUsingGeoHashing\\bin\\x64\\Release\\input\\"
inputfile = "1.txt"
puts dir

 Dir.glob(dir.gsub('\\','/') + "*.txt") do | file | 
   # #for each file
    file = File.basename(file)
    puts "working on: #{file}...."
   
   #1) function
   # File.open(dir + File.basename(file), 'w') do | f |

       # File.open(file).readlines.collect do | line |
           # #for each line
           # puts "working on: #{line}"
           # arr = line.chomp.split

           # #remove the last two column
           # arr.delete_at(13)
           # arr.delete_at(13)

           # #write to target file           
           # f.puts arr.join(" ") + "\n"
       # end

   # f.close()

   # end
   
    # #2)function
	#File.open(dir + inputfile, 'w') do | f |

        #File.open(file).readlines.collect do | line |
           #for each line
           #puts "working on: #{line}"
           # arr = line.chomp.split

           # #remove the last two column
           # arr.delete_at(13)
           # arr.delete_at(13)

           # #write to target file           
           # f.puts arr.join(" ") + "\n"
       # end

   # f.close()

   # end
   
 end