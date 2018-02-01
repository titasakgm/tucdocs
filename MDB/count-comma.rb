#!/usr/bin/ruby

inp = ARGV[0]

old_comma = 0
src = open(inp).readlines
src.each do |line|
  new_comma = line.count(',')
  if new_comma != old_comma
    puts "old_comma: #{old_comma} => new_comma: #{new_comma}"
    old_comma = new_comma
  end
end

