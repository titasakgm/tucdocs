#!/usr/bin/ruby

nr = open("R-xls").readlines
nr.each do |f|
  xls = f.chomp
  # next if xls !~ /CASCADE/ 
  cmd = "./import-R-xls.rb '#{xls}' "
  puts cmd
  system(cmd)
end

