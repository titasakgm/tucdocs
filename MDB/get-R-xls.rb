#!/usr/bin/ruby

def save_r(xls)
  fp = open("R-xls","a")
  fp.write("#{xls}\n")
  fp.close
end

entries = Dir.glob("/opt/tucdocs/XLS/Budget\ plan\ FY\ 2018/**/*")

entries.sort.each do |f|
  next if f !~ /.xls/
  save_r(f)
end

