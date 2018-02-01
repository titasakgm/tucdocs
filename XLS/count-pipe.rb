#!/usr/bin/ruby

def count(f)
  puts "file: #{f}"
  src = open(f).readlines
  src.each do |line|
    pipes = line.count('|')
    puts "pipes: #{pipes}"
    exit if pipes != 21
  end
end
 
entries = Dir.glob("BUDGET-PLAN/**/*")

entries.each do |f|
  count(f)
end

