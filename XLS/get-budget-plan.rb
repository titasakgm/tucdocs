#!/usr/bin/ruby

entries = Dir.glob("Budget plan FY 2018/**/*")

entries.each do |f|
  next if f !~ /.xls/
  puts f
end

