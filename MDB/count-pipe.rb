#!/usr/bin/ruby

inp = ARGV[0]

src = open(inp).readlines
n = 0
src.each do |line|
  n += 1
  pipe = line.count('|')
  puts "Line:#{n} => #{pipe} pipes"
end

