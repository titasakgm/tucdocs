#!/usr/bin/ruby

require 'pg'

# Check number of records in each TABLE
# should match number of lines in <DATABASE>_<TABLE>.csv
# in folder /opt/tucdocs/MDB

def check_csv(db,tbl)
  csv = "/opt/tucdocs/MDB/#{db}_#{tbl}.csv"
  puts "csv: #{csv}"
  num_csv = %x! wc -l #{csv} !.chomp.to_s.to_i
end

def check_rows(db)
  db = db.sub('&','and')
  tbls = ["Amendment","BudgetAmend","Budget","CoAgYear","ObjectClass","Program"]
  tbls += ["Project","ProjectSubproject","Receive","Spend","Subproject","User"]
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  tbls.each do |tbl|
    sql = "SELECT count(*) AS cnt "
    sql += "FROM \"#{tbl}\" "
    res = con.exec(sql)
    num_recs = res[0]['cnt'].to_s.to_i
    num_csv = check_csv(db,tbl)
    if num_recs == num_csv
      puts "Checking #{db}:#{tbl} num_recs: #{num_recs} and num_csv: #{num_csv} PASS!"
    else
      puts "Checking #{db}:#{tbl} num_recs: #{num_recs} and num_csv: #{num_csv} FAIL!"
      exit
    end
  end
end

def check_if_exists?(db)
  db = db.sub('&','and')
  con = PG::Connection.connect("localhost",5432,nil,nil,"template1","admin")
  sql = "SELECT 1 AS result FROM pg_database "
  sql += "WHERE datname='#{db}' "
  puts sql
  res = con.exec(sql)
  con.close
  result = res[0]['result']
  flag = (result == '1') ? true : false
end

r = open("R-tables").readlines
nr = open("NR-tables").readlines

puts "R-tables"
n = 0
r.each do |line|
  #next # check only Non-Research
  n += 1
  db = line.chomp
  flag = check_if_exists?(db) ? "EXISTS" : "NOT EXISTS"
  puts "#{db} #{flag}"
  flag = check_rows(db)
end
puts "Total: #{n} databases"

puts "NR-tables"
n = 0
nr.each do |line|
  #next # check only Research
  n += 1
  db = line.chomp
  #next if db !~ /???/ # check only 1 table
  flag = check_if_exists?(db) ? "EXISTS" : "NOT EXISTS"
  puts "#{db} #{flag}"
  flag = check_rows(db)
end

puts "Total: #{n} databases"

