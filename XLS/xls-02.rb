#!/usr/bin/ruby

require_relative 'tuc-utils'

fn = ARGV[0]
if fn.nil?
  puts "usage: ./xls-01.rb <XLS Filename>\n"
  exit(0)
end

tuc = Tuc.new(fn)

# project title
a01 = tuc.cell(1,1)
puts "a01: #{a01}"

# projectcode
a02 = tuc.cell(2,1)
puts "a02: #{a02}"
projectcode = a02.split('(').last.tr(')','')
puts "projectcode: #{projectcode}"

# budget approved
a03 = tuc.cell(3,1)
c03 = tuc.cell(3,3)
puts "a03: #{c03}"
puts "c03: #{c03}"

# cash on hand
a04 = tuc.cell(4,1)
c04 = tuc.cell(4,3)
puts "a04: #{a04}"
puts "c03: #{c04}"

# carry over
a05 = tuc.cell(5,1)
c05 = tuc.cell(5,3)
puts "a05: #{a05}"
puts "c05: #{c05}"

# newly purpose
a06 = tuc.cell(6,1)
c06 = tuc.cell(6,3)
puts "a06: #{a06}"
puts "c06: #{c06}"

# Headers
a07 = tuc.cell(7,1)
puts "a07: #{a07}"
e07 = tuc.cell(7,5)
puts "e07: #{e07}"
i07 = tuc.cell(7,9)
puts "i07: #{i07}"
m07 = tuc.cell(7,13)
puts "m07: #{m07}"
q07 = tuc.cell(7,17)
puts "q07: #{q07}"
u07 = tuc.cell(7,21)
puts "u07: #{u07}"
v07 = tuc.cell(7,22)
puts "v07: #{v07}"

# Subheaders
b08 = tuc.cell(8,2)
puts "b08: #{b08}"
c08 = tuc.cell(8,3).tr("\n",' ').squeeze(' ')
puts "c08: #{c08}"
d08 = tuc.cell(8,4).tr("\n",' ').squeeze(' ')
puts "d08: #{d08}"

# Quarter #1
e08 = tuc.cell(8,5)
puts "e08: #{e08}"
f08 = tuc.cell(8,6)
puts "f08: #{f08}"
g08 = tuc.cell(8,7)
puts "g08: #{g08}"
h08 = tuc.cell(8,8)
puts "h08: #{h08}"

# Quarter #2
i08 = tuc.cell(8,9)
puts "i08: #{i08}"
j08 = tuc.cell(8,10)
puts "j08: #{j08}"
k08 = tuc.cell(8,11)
puts "k08: #{k08}"
l08 = tuc.cell(8,12)
puts "l08: #{l08}"

# Quarter #3
m08 = tuc.cell(8,13)
puts "m08: #{m08}"
n08 = tuc.cell(8,14)
puts "n08: #{n08}"
o08 = tuc.cell(8,15)
puts "o08: #{o08}"
p08 = tuc.cell(8,16)
puts "p08: #{p08}"

# Quarter #4
q08 = tuc.cell(8,17)
puts "q08: #{q08}"
r08 = tuc.cell(8,18)
puts "r08: #{r08}"
s08 = tuc.cell(8,19)
puts "s08: #{s08}"
t08 = tuc.cell(8,20)
puts "t08: #{t08}"

# summary: total expense, balance
u08 = tuc.cell(8,21)
puts "u08: #{u08}"
v08 = tuc.cell(8,22)
puts "v08: #{v08}"
