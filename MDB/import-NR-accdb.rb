#!/usr/bin/ruby

require 'pg'
require 'pry'

def check_db(dbname)
  con = PG::Connection.connect("localhost",5432,nil,nil,"template1","admin")
  sql = "SELECT 1 as result "
  sql += "FROM pg_database "
  sql += "WHERE datname='#{dbname}' "
  res = con.exec(sql)
  con.close
  return res.num_tuples
end

def process_mdb(accdb)
  # 1 get ProjectID from accdb => dbname
  dbname = accdb.split(' ').last.split('.').first.downcase
  puts "accdb: #{accdb}"
  puts "dbname: #{dbname}"

  # 2 create database for each project IF NOT EXISTS
  flag = check_db(dbname)
  puts "check_db: #{flag}"
  if flag == 0 # dbname not exists
    cmd = "createdb #{dbname}"
    system(cmd)
  end

  # 3 auto-import .accdb to dbname
  db = accdb.gsub(' ','\\\ ')
  cmd = "./auto-import-accdb.rb '#{db}' #{dbname}"
  puts "cmd: #{cmd}"
  system(cmd)
end

entries = Dir.glob("Year02 CoAg FIN_NR/**/*")

agg = "KPIS|PREP2START-SL|YMSM"

n = 0
entries.each do |f|
  next if f !~ /.accdb$/
  if f.upcase.scan(/AGGREGATE/).length > 0
    next if f.upcase =~ /NON-RESEARCH/
    if f.upcase.scan(/#{agg}/).length > 0
      n += 1
    end
  else
    next if f.upcase.scan(/#{agg}/).length > 0
    n += 1
  end
  puts "Process accdb ##{n} #{f}..."
  process_mdb(f)
end

