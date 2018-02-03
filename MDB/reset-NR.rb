#!/usr/bin/ruby

require 'pg'

def dropdb(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"template1","admin")
  sql = "DROP DATABASE \"#{db}\" "
  puts "sql: #{sql}"
  begin
    res = con.exec(sql)
  rescue
    puts "Database #{db} not existed"
  end
  con.close
end

dbs = open("NR-tables").readlines
dbs.each do |db|
  dropdb(db.chomp)
end

# Delete ALL .csv
# Delete ALL create-*.sq;

cmd = "rm -rf *.csv"
puts cmd
system(cmd)

cmd = "rm -rf create-*.sql"
puts cmd
system(cmd)


