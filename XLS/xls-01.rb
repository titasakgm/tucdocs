#!/usr/bin/ruby

require 'roo-xls'

def xdata(xls,row,col)
  dat = xls.cell(row,col)
  dat = dat.tr("\n",' ').squeeze(' ')
end

fn = ARGV[0]
if fn.nil?
  puts "usage: ./xls-01.rb <XLS Filename>\n"
  exit(0)
end

xl = Roo::Spreadsheet.open(fn)

# project title
a0101 = xdata(xl,1,1)
puts "a0101: #{a0101}"

# projectcode
a0201 = xl.cell(2,1)
puts "a0201: #{a0201}"
projectcode = a0201.split('(').last.tr(')','')
puts "projectcode: #{projectcode}"

# budget approved
a0301 = xl.cell(3,1)
a0303 = xl.cell(3,3)
puts "a0301: #{a0301}"
puts "a0303: #{a0303}"

# cash on hand
a0401 = xl.cell(4,1)
a0403 = xl.cell(4,3)
puts "a0401: #{a0401}"
puts "a0403: #{a0403}"

# carry over
a0501 = xl.cell(5,1)
a0503 = xl.cell(5,3)
puts "a0501: #{a0501}"
puts "a0503: #{a0503}"

# newly purpose
a0601 = xl.cell(6,1)
a0603 = xl.cell(6,3)
puts "a0601: #{a0601}"
puts "a0603: #{a0603}"

# Headers
a0701 = xl.cell(7,1)
puts "a0701: #{a0701}"
a0705 = xl.cell(7,5)
puts "a0705: #{a0705}"
a0709 = xl.cell(7,9)
puts "a0709: #{a0709}"
a0713 = xl.cell(7,13)
puts "a0713: #{a0713}"
a0717 = xl.cell(7,17)
puts "a0717: #{a0717}"
a0721 = xl.cell(7,21)
puts "a0721: #{a0721}"
a0722 = xl.cell(7,22)
puts "a0722: #{a0722}"

# Subheaders
a0802 = xl.cell(8,2)
puts "a0802: #{a0802}"
a0803 = xl.cell(8,3).tr("\n",' ').squeeze(' ')
puts "a0803: #{a0803}"
a0804 = xl.cell(8,4).tr("\n",' ').squeeze(' ')
puts "a0804: #{a0804}"

a0812 = xl.cell(8,12).tr("\n",' ').squeeze(' ')
puts "a0812: #{a0812}"

