#!/usr/bin/ruby

# Count .csv for ref_comma in HEADER LINE

csv = ARGV[0]
src = open(csv).readlines
dst = open("tmp","w")

ref_comma = 0
old_line = nil
c1 = 0
src.each do |line|
  comma = line.count(',')
  if ref_comma == 0
    ref_comma = comma
    dst.write(line) # HEADER LINE
  elsif comma < ref_comma
    if c1 == 0
      c1 = comma
      old_line = line.chomp
    else
      line = old_line + line
      dst.write(line)
      c1 = 0
    end
  else
    dst.write(line)
  end
end

dst.close

# Rename tmp to original .csv file
File.rename('tmp',csv)

