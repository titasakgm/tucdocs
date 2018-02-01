#!/usr/bin/ruby

require 'fileutils'

fn = ARGV[0]
if fn.nil?
  puts "usage: ./replace-comma-between-quotes.rb <SRC>\n"
  exit(0)
end

if !File.exists?(fn)
  puts "Error: cannot open file #{fn}\n"  
  exit(1)
end

src = open(fn).readlines
dst = open("tmp","w")

q = 0
linex = ''
src.each do |line|
  arr = line.split('')
  arr.each do |c|
    if c == '"'
      q += 1
    end
    if c == ',' and q % 2 == 1
      c = ':'
    end
    linex << c
  end
  dst.write(linex)
  linex = ''
end

dst.close

# replace original file with tmp
FileUtils.mv('tmp',fn)

