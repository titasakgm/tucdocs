#!/usr/bin/ruby

require 'pg'

def get_rows(db,tbl)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","postgres")
  sql = "SELECT count(*) as cnt FROM \"#{tbl}\" "
  res = con.exec(sql)
  con.close
  rows = res[0]['cnt']
end

def get_tables(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","postgres")
  sql = "SELECT table_name FROM information_schema.tables "
  sql += "ORDER BY table_name "
  res = con.exec(sql)
  con.close
  tbls = []
  res.each do |rec|
    tbl = rec['table_name']
    next if tbl !~ /^[A-Z]/
    tbls.push(tbl)
  end
  tbls
end

db = ARGV[0]
if db.nil?
  puts "usage: #{$0} <Database Name>\n"
  exit(0)
end

tbls = get_tables(db)
puts tbls.join('|')

tbls.each do |tbl|
  rows = get_rows(db,tbl)
  puts "#{tbl} => #{rows} rows"
end
