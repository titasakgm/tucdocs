#!/usr/bin/ruby

def find_accdb(mdb)
  accdb = 'NA'
  src = open("R-accdbs").readlines
  src.each do |line|
    next if line.upcase !~ /#{mdb.upcase}.ACCDB/
    accdb = line.chomp
  end
  accdb
end

n = 0
src = open("R-tables").readlines
src.each do |line|
  tbl = line.chomp
  mdb = tbl.upcase.tr('_','-')
  accdb = find_accdb(mdb)
  puts "tbl: #{tbl} mdb: #{mdb} => accdb: #{accdb}"
  n += 1
  cmd = "./import-R-accdb.rb \"#{accdb}\" "
  puts "#{n}: #{cmd}"
  system(cmd)
end
