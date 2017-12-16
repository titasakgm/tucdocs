#!/usr/bin/ruby

require 'pg'

def insert(tbl,arr)
  (0...arr.size).each do |n|
    if arr[n] =~ /\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d/
      dt = Date.strptime(arr[n],"%m/%d/%y")
      arr[n] = dt.strftime("%Y%m%d")
    end
  end
  con = PG::Connection.connect("localhost",5432,nil,nil,"test")
  sql = "INSERT INTO #{tbl} VALUES ('"
  sql += arr.join("','")
  sql += "')"
  puts sql
  res = con.exec(sql)
  con.close
end

header = open("budget.csv").readline.chomp.downcase.split(',')

sql = "CREATE TABLE budget (\n"
header.each do |c|
  sql += "  #{c} varchar,\n"
end
sql = sql.chomp.chop + ");"

fn = open("create-budget.sql","w")
fn.write(sql)
fn.close

dat = open("budget.csv").readlines
n = 0
dat[1..-1].each do |line|
  n += 1
  if line.count(',') != 23
    puts line
    exit
  end
  insert('budget',line.chomp.tr('"','').split(','))
end

