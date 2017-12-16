#!/usr/bin/ruby

require 'pg'

# READ TBL:Budget get AmendNo to popuplate TBL:budget_amend

db = ARGV[0]
if db.nil?
  puts "usage: ./budget-amend.rb <DBNAME>\n"
  exit(0)
end

con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
sql = "SELECT \"CoAgYear\",\"ProjectID\",\"ObjectClassID\","
sql += "\"ItemNo\",\"AmendNo\",

