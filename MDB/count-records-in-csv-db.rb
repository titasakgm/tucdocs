#!/usr/bin/ruby

require 'pg'

def count_num_recs(db,tbl)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT count(*) AS cnt "
  sql += "FROM \"#{tbl}\" "
  res = con.exec(sql)
  con.close
  rum_recs = res[0]['cnt'].to_s.to_i
end

# Get all <db>_<Table>.csv
# count num rows in .csv using wc -l
# count num_recs in <Table>
# compare
# report IF NOT EQUAL

entries = Dir.entries(".") - ['.','..']
entries.sort.each do |f|
  next if f !~ /.csv$/
  dbtbl = f.split('_')
  tbl = dbtbl.last.split('.').first
  dbtbl.pop
  db = dbtbl.join('_')

  num_lines = %x! wc -l #{f} !.chomp.split(' ').first.to_i
  num_recs = count_num_recs(db,tbl)

  if num_lines == num_recs
    puts "DB:#{db} TBL:#{tbl} => #{num_recs} records PASSED!"
  else
    puts "FAILED!! DB:#{db} TBL:#{tbl} => num_lines:#{num_lines} num_recs:#{num_recs}"
    exit
  end
end

