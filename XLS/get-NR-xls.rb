#!/usr/bin/ruby

def save_nr(xls)
  fp = open("NR-xls","a")
  fp.write("#{xls}\n")
  fp.close
end

# XLS of NR Projects
entries = Dir.glob("/opt/tucdocs/XLS/Budget\ plan\ FY\ 2018/**/*")

entries.sort.each do |f|
  next if f !~ /.xls/
  save_nr(f)
end

