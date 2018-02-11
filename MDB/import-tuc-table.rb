#!/usr/bin/ruby

require 'pg'
require 'fileutils'

def get_rows(db,tbl)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT count(*) AS cnt "
  sql += "FROM \"#{tbl}\" "
  res = con.exec(sql)
  con.close
  rows = res[0]['cnt']
end

def log_error(msg)
  log = open("import-tuc-table-ERROR.log","a")
  log.write(msg)
  log.write("\n")
  log.close
end

def check_amendment_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"Amendment\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"ProjectID\"='#{arr[1]}' "
  sql += "AND \"SubprojectID\"='#{arr[2]}' AND \"AmendNo\"='#{arr[3]}' "
  sql += "AND \"AmendRefNo\"='#{arr[4]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_objectclass_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"ObjectClassID\" FROM \"ObjectClass\" "
  sql += "WHERE \"ObjectClassID\"='#{arr[0]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_program_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"ProgramID\" FROM \"Program\" "
  sql += "WHERE \"ProgramID\"='#{arr[0]}' AND \"ProgramName\"='#{arr[1]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_projectsubproject_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"ProjectSubproject\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"ProjectID\"='#{arr[1]}' "
  sql += "AND \"SubprojectID\"='#{arr[2]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_receive_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"Receive\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"ProjectID\"='#{arr[1]}' "
  sql += "AND \"SubprojectID\"='#{arr[2]}' AND \"DateReceived\"='#{arr[3]}' "
  sql += "AND \"ReceiveNo\"='#{arr[4]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_spend_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"Spend\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"ProjectID\"='#{arr[1]}' "
  sql += "AND \"SubprojectID\"='#{arr[2]}' AND \"ObjectClassID\"='#{arr[3]}' "
  sql += "AND \"ItemNo\"='#{arr[4]}' AND \"SpendNo\"='#{arr[5]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_user_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"UserId\" FROM \"User\" "
  sql += "WHERE \"UserId\"='#{arr[0]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_project_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"ProjectID\" FROM \"Project\" "
  sql += "WHERE \"ProjectID\"='#{arr[0]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_subproject_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"SubprojectID\" FROM \"Subproject\" "
  sql += "WHERE \"SubprojectID\"='#{arr[0]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_coagyear_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"CoAgYear\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"PeriodFrom\"='#{arr[1]}' "
  sql += "AND \"PeriodTo\"='#{arr[2]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

def check_budget_dup(db,arr)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" FROM \"Budget\" "
  sql += "WHERE \"CoAgYear\"='#{arr[0]}' AND \"ProjectID\"='#{arr[1]}' AND "
  sql += "\"SubprojectID\"='#{arr[2]}' AND \"ObjectClassID\"='#{arr[3]}' "
  sql += "AND \"ItemNo\"='#{arr[4]}' AND \"AmendNo\"='#{arr[5]}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found == 0) ? false : true
end

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
  if tbl == 'Budget'
    flag = check_budget_dup(db,arr)
    if flag
      puts "!!!! Budget DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'CoAgYear'
    flag = check_coagyear_dup(db,arr)
    if flag
      puts "!!!! CoAgYear DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Project'
    flag = check_project_dup(db,arr)
    if flag
      puts "!!!! Project DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Subproject'
    flag = check_subproject_dup(db,arr)
    if flag
      puts "!!!! Subproject DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'User'
    flag = check_user_dup(db,arr)
    if flag
      puts "!!!! User DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Spend'
    flag = check_spend_dup(db,arr)
    if flag
      puts "!!!! Spend DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Receive'
    flag = check_receive_dup(db,arr)
    if flag
      puts "!!!! Receive DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'ProjectSubproject'
    flag = check_projectsubproject_dup(db,arr)
    if flag
      puts "!!!! ProjectSubproject DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Program'
    flag = check_program_dup(db,arr)
    if flag
      puts "!!!! Program DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'ObjectClass'
    flag = check_objectclass_dup(db,arr)
    if flag
      puts "!!!! ObjectClass DUP !!!!"
      puts arr.join('!')
      return
    end
  elsif tbl == 'Amendment'
    flag = check_amendment_dup(db,arr)
    if flag
      puts "!!!! Amendment DUP !!!!"
      puts arr.join('!')
      return
    end
  end

  # NO NEED to format Date because mdb-export use -D '%Y%m%d'

  # replace single quote in arr to '' DOUBLE SINGLE QUOTE for PostgreSQL
  (0...arr.length).each do |n|
    arr[n] = arr[n].gsub("'","''")
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
db = ARGV[1].sub('&','and')
tbl = ARGV[2]

if tbl.nil?
  puts "usage: ./import-tuc-table.rb <.accdb NAME> <DBNAME> <TABLE NAME>\n"
  exit(0)
end

# export table from DB NAME (.accdb)
if File.exists?("#{db}_#{tbl}.csv")
  FileUtils.rm_rf("#{db}_#{tbl}.csv")
end

# DELETE coach_1_Project_o.csv ONLY 1 EXCEPTION
if tbl =~ /Project_o/
  tbl = 'Project_o'
  puts "EXCEPTION: DO NOT PROCESS THIS TABLE: #{tbl}"
  exit
end

cmd = "mdb-export -d '|' -D '%Y%m%d' -Q -R '!' \"#{accdb}\" \"#{tbl}\" > #{db}_#{tbl}.csv"
puts "cmd1: #{cmd}"
system(cmd)

# FIX data with newline inside => <tbl>.csv has > 1 line BEFORE NEXT STEP
src = open("#{db}_#{tbl}.csv").readlines
dst = open("#{db}_#{tbl}.csv","w")

if src.length == 1
  dst.write(src[0].split('!').join("\n"))
  dst.close
else # newline within data field!!!
  # join all lines into 1 line > remove \n > split with ! > rejoin with \n
  src = src.join(' ').gsub(/\n/,'').gsub(/\r/,'') 
  dst.write(src.split('!').join("\n"))
  dst.close
end

# get table header -> column (field)
header = open("#{db}_#{tbl}.csv").readline.chomp.split('|')

sql = "CREATE TABLE \"#{tbl}\" (\n"
header.each do |c|
  sql += "  \"#{c}\" varchar,\n"
end
sql = sql.chomp.chop + ");"

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

# NO NEED!!
# remove comma within quotes
# cmd = "./replace-comma-between-quotes.rb #{db}_#{tbl}.csv"
# system(cmd)

# fix record split to 2 or 3 lines by counting pipe in HEADER LINE
# cmd = "./fix-field-count.rb #{db}_#{tbl}.csv"
# system(cmd)

dat = open("#{db}_#{tbl}.csv").readlines # Array output

n = 0
dat[1..-1].each do |line|
  flds = line.chomp.split('|')
  insert(db,tbl,flds)
end

rows = get_rows(db,tbl)
puts "TABLE: #{tbl} has #{rows} rows"
