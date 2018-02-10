#!/usr/bin/ruby

folder = ARGV[0]
outp = ARGV[1]
if outp.nil?
  puts "usage: #{$0} <XLS FOLDER> <OUTPUT FILE>\n"
  exit(0)
end

fp = open(outp,"w")
entries = Dir.glob("#{folder}/**/*")
entries.sort.each do |f|
  puts f
  next if f !~ /.xls/
  fp.write(f)
  fp.write("\n")
end

fp.close

