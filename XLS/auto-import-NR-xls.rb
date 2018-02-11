#!/usr/bin/ruby

nr = open("NR-xls").readlines
nr.each do |f|
  xls = f.chomp

  next if xls !~ /YMSM/

  cmd = "./import-NR-xls.rb '#{xls}' "
  puts cmd
  system(cmd)
end

