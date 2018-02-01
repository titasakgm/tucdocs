#!/usr/bin/ruby

accdb = ARGV[0]
db = ARGV[1]

if accdb.nil?
  puts "usage: ./auto-import-accdb.rb <.accdb SRC> <DBNAME>\n"
  exit(0)
end

tbl = %x! mdb-tables #{accdb} !
tbls = tbl.split(' ')
db = db.tr('&','and')

tbls.each do |tbl|
  cmd = "./import-tuc-table.rb #{accdb} #{db} #{tbl}"
  puts cmd
  system(cmd)
end
