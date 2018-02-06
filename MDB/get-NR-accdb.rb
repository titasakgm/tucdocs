#!/usr/bin/ruby

def save_nr(accdb)
  fp = open("NR-accdbs","a")
  fp.write("#{accdb}\n")
  fp.close
end

entries = Dir.glob("Year02 CoAg FIN_NR/**/*")

entries.sort.each do |f|
  next if f !~ /accdb$/
  save_nr(f)
end


