#!/usr/bin/ruby

require_relative 'tuc-utils'

fn = ARGV[0]
if fn.nil?
  puts "usage: ./xls-03.rb <XLS Filename>\n"
  exit(0)
end

tuc = Tuc.new(fn)

col = tuc.col(2)
puts "col: #{col}"
