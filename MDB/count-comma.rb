#!/usr/bin/ruby

inp = ARGV[0]

src = open(inp).readlines
n = 0
src.each do |line|
  n += 1
  comma = line.count(',')
  puts "Line:#{n} => #{comma} commas"
end

