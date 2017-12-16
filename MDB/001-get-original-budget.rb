#!/usr/bin/ruby

require 'pg'

def get_original_budget(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"ProjectID\",\"ObjectClassID\",sum(float4(\"Total\")) as sum "
  sql += "FROM \"Budget\" "
  sql += "WHERE \"AmendNo\"='0' "
  sql += "GROUP BY \"ProjectID\",\"ObjectClassID\" "
  sql += "ORDER BY \"ObjectClassID\" "
  res = con.exec(sql)
  con.close
  info = []
  total = 0
  pid = nil
  n = 0
  res.each do |rec|
    n += 1
    pid = rec["ProjectID"]
    oid = rec["ObjectClassID"].to_i
    sum = rec["sum"]
    total += sum.to_i
    if oid == n
      info.push("#{pid}|#{oid}|#{sum}")
    else
      (n...oid).each do |x|
        info.push("#{pid}|#{x}|0")
      end
      info.push("#{pid}|#{oid}|#{sum}")
    end
  end
  info.push("#{pid}|Total|#{total}")
end

db = ARGV[0]
if db.nil?
  puts "usage: ./001-get-original-budget.rb <DBNAME>\n"
  exit(0)
end

budget = get_original_budget(db)
puts budget
