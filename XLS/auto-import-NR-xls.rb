#!/usr/bin/ruby

nr = open("NR-xls").readlines
nr.each do |f|
  xls = f.chomp
  cmd = "./import-xls.rb '#{xls}' "
  puts cmd
  system(cmd)
end

