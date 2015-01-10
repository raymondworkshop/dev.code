# -*- coding: utf-8 -*-
#   @author wenlong 
#
#   Functions:  
#     1). remove the last columns for each file
#

#target dir
dir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/target/"
#dtdir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/source/"
dtdir = "/home/zhaowenlong/workspace/proj/dev.mycode/ruby/data/hammingball/4order/data/"
target = dir + "1_.txt"
#source = dir + "1_0.01.txt"

def sum(array)
    return array.inject(0) { | sum, x | sum + x }
end

def mean(array)
    return sum(array) / array.length.to_f
end

def standard_deviation(array)
    m = mean(array)
    variance = array.inject(0) { | variance, x | variance += (x - m) ** 2 }
    
    return Math.sqrt( variance / (array.length - 1).to_f )
end


#store the output
data = Array.new()

# write the result in target
File.open(target, 'w') do | f |
    
    Dir.glob(dtdir + "*.txt") do | file |    
        #for each file
        puts "working on: #{file} ..."
        
        #store the data in each file
        arr = Array.new()
        File.open(file).readlines.collect do | line |
            #for each line
            #puts "working on: #{line}"

            arr.push(line.chomp)
        end
        #puts arr
        data.push(arr)
    end

    #puts data
    data.transpose.each do | temp |
        #puts "The data: #{temp}"
        puts "The temp: #{temp}"

        mcc = Array.new()
        output = Array.new()
        str = ""
        temp.each do | minu |
            #puts "#{minu}"
            arr1 = minu.chomp.split(":")

            str = arr1[0] + ":" + arr1[1] 
            #output.push(arr1[0])
            #output.push(arr1[1])
            #push the resolution in mcc
            mcc.push(arr1[2].to_f)
        end
        
        #puts str
        output = str.split(":")
        #puts output
        #puts mcc
        
        #puts "mean:"
        #puts mean(mcc)
        #output.push(mean(mcc))
        #puts "deviation:"
        output.push(standard_deviation(mcc))
        #mcc.each do

        f.puts output.join(":")
    end

    f.close()
end
