#!/usr/bin/ruby

# Count .csv for ref_pipe in HEADER LINE

csv = ARGV[0]
src = open(csv).readline.chomp
dst = open("tmp","w")

ref_pipe = 0
old_line = nil
c1 = 0
src.split('!').each do |line|
  pipe = line.count('|')
  if ref_pipe == 0
    ref_pipe = pipe
  elsif pipe < ref_pipe
    puts "ERROR: #{csv} => #{line} (#{ref_pipe} => #{pipe})"
    exit
    if c1 == 0
      c1 = pipe
      old_line = line.chomp
      next
    else
      if pipe + c1 == ref_pipe 
        line = old_line + line
      else
        c1 += pipe
        old_line = old_line + line.chomp
        next
      end
    end
  end
  dst.write(line)
  old_line = nil
  c1 = 0
end

dst.close

# Rename tmp to original .csv file
File.rename('tmp',csv)

