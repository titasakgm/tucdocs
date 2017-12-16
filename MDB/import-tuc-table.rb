#!/usr/bin/ruby

require 'pg'

def check_if_exists?(db,tbl)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT relname "
  sql += "FROM pg_class "
  sql += "WHERE relname = '#{tbl}' "
  puts "sql1: #{sql}"
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = false
  flag = true if found == 1
end

def insert(db,tbl,arr)
  (0...arr.size).each do |n|
    if arr[n] =~ /\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d/
      dt = Date.strptime(arr[n],"%m/%d/%y")
      arr[n] = dt.strftime("%Y%m%d")
    end
  end
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "INSERT INTO \"#{tbl}\" VALUES ('"
  sql += arr.join("','")
  sql += "')"
  puts "sql2: #{sql}"
  res = con.exec(sql)
  con.close
end

accdb = ARGV[0]
db = ARGV[1]
tbl = ARGV[2]

if tbl.nil?
  puts "usage: ./import-tuc-table.rb <.accdb NAME> <DBNAME> <TABLE NAME>\n"
  exit(0)
end

# export table from DB NAME (.accdb)
cmd = "mdb-export #{accdb} #{tbl} > #{tbl}.csv"
puts "cmd1: #{cmd}"
system(cmd)

# get table header -> column (field)
header = open("#{tbl}.csv").readline.chomp.split(',')

sql = "CREATE TABLE \"#{tbl}\" (\n"
header.each do |c|
  sql += "  \"#{c}\" varchar,\n"
end
sql = sql.chomp.chop + ");"

puts "sql3: #{sql}"

fn = "create-#{tbl}.sql"
fp = open(fn,"w")
fp.write(sql)
fp.close

flag = check_if_exists?(db,tbl)
if !flag
  # create table
  cmd = "psql #{db} < #{fn}"
  puts "cmd1: #{cmd}"
  system(cmd)
else
  puts "Table #{tbl} exists"
end

# remove comma within quotes
cmd = "./replace-comma-between-quotes.rb #{tbl}.csv"
system(cmd)

dat = open("#{tbl}.csv").readlines
n = 0
dat[1..-1].each do |line|
  insert(db,tbl,line.chomp.tr('"','').split(','))
end
