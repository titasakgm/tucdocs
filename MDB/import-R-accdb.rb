#!/usr/bin/ruby

require 'pg'
require 'pry'

def log(msg)
  fp = open("import-R.log","a")
  fp.write(msg)
  fp.write("\n")
  fp.close
end

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

  # change - in dbname to _
  dbname = dbname.tr('-','_')

  puts "accdb: #{accdb}"
  puts "dbname: #{dbname}"

  # 2 create database for each project IF NOT EXISTS
  flag = check_db(dbname)
  puts "check_db: #{flag}"
  if flag == 0 # dbname not exists
    cmd = "createdb #{dbname}"
    puts "cmd: #{cmd}"
    system(cmd)
  end

  # 3 auto-import .accdb to dbname
  db = accdb.gsub(' ','\\\ ')
  cmd = "./auto-import-accdb.rb '#{db}' #{dbname}"
  puts "cmd: #{cmd}"
  system(cmd)
end

entries = Dir.glob("Year02 CoAg FIN_MoPH-R/**/*")

n = 0
entries.each do |f|
  next if f !~ /.accdb$/
  #next if f.upcase =~ /AGGREGATE/
  n += 1
  puts "Process accdb ##{n} #{f}..."
  process_mdb(f)
end
