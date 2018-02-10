#!/usr/bin/ruby

def save_r(accdb)
  fp = open("R-accdbs","a")
  fp.write("#{accdb}\n")
  fp.close
end

entries = Dir.glob("Year02 CoAg FIN_MoPH-R/**/*")

entries.sort.each do |f|
  next if f !~ /accdb$/
  save_r(f)
end
