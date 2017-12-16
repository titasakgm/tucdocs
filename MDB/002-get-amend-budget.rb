#!/usr/bin/ruby

require 'pg'

def check_dup(yr,pid,oid,itemno,amendno)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT id FROM \"Budget\" "
  sql += "WHERE \"CoAgYear\"='#{yr}' AND \"ProjectID\"='#{pid}' "
  sql += "AND \"ObjectClassID\"='#{oid}' AND \"ItemNo\"='#{itemno}' "
  sql += "AND \"AmendNo\"='#{amendno}' "
  res = con.execc(sql)
  found = res.num_tuples
  return (found > 0) ? true : false
end

def insert_amend(db,yr,pid,oid,itemno,amendno,sum,datec,dateu)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "INSERT INTO budget_amend (coagyear,project_id,"
  sql += "object_class_id,item_no,amend_no,total) "
  sql += "VALUES ('#{yr}','#{pid}','#{oid}','#{itemno}','#{amendno}',"
  sql += "'#{sum}') "
  #puts "insert_amend: #{sql}"
  res = con.exec(sql)
  con.close
end

def update_amend(db,yr,pid,oid,itemno,amendno,sum,datec,dateu)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "UPDATE budget_amend SET amend_no='#{amendno}',"
  sql += "total='#{sum}',date_created='#{datec}',"
  sql += "date_updated='#{dateu}' "
  sql += "WHERE coagyear='#{yr}' AND project_id='#{pid}' "
  sql += "AND object_class_id='#{oid}' AND item_no='#{itemno}'"
  sql += "AND amend_no='#{amendno}' "
  puts "update_amend: #{sql}"
  res = con.exec(sql)  
  con.close
end

def copy_amend(db,amendno)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT coagyear,project_id,object_class_id,item_no,"
  sql += "amend_no,total "
  sql += "FROM budget_amend "
  sql += "WHERE amend_no = #{amendno-1} "
  #puts "copy_amend1: #{sql}"
  res = con.exec(sql)
  res.each do |rec|
    yr = rec['coagyear']
    pid = rec['project_id']
    oid = rec['object_class_id']
    itemno = rec['item_no']
    total = rec['total']
    sql = "INSERT INTO budget_amend(coagyear,project_id,"
    sql += "object_class_id,item_no,amend_no,total) "
    sql += "VALUES('#{yr}','#{pid}','#{oid}','#{itemno}',"
    sql += "'#{amendno}','#{total}') "
    #puts "copy_amend2: #{sql}"
    res2 = con.exec(sql)    
  end
  con.close
end

def populate_amend(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" as yr,\"ProjectID\" as pid,\"ObjectClassID\" as oid,"
  sql += "\"ItemNo\" as itemno,\"AmendNo\" as amendno,"
  sql += "\"Total\" as sum,_datecreated,_dateupdated "
  sql += "FROM \"Budget\" "
  sql += "WHERE \"AmendNo\"='0' "
  sql += "ORDER BY \"ObjectClassID\",\"ItemNo\",\"AmendNo\" "
  res = con.exec(sql)
  con.close
  info = []
  total = 0
  pid = nil
  n = 0
  res.each do |rec|
    n += 1
    yr = rec["yr"]
    pid = rec["pid"]
    oid = rec["oid"].to_i
    itemno = rec["itemno"].to_i
    amendno = rec["amendno"].to_i
    sum = rec["sum"].to_f
    datec = rec["_datecreated"]
    dateu = rec["_dateupdated"]
    insert_amend(db,yr,pid,oid,itemno,amendno,sum,datec,dateu)
  end
end

def process_amend(db)
  max_amend = 0
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" as yr,\"ProjectID\" as pid,\"ObjectClassID\" as oid,"
  sql += "\"ItemNo\" as itemno,\"AmendNo\" as amendno,"
  sql += "\"Total\" as sum,_datecreated,_dateupdated "
  sql += "FROM \"Budget\" "
  sql += "WHERE \"AmendNo\">'0' "
  sql += "ORDER BY \"AmendNo\",\"ObjectClassID\",\"ItemNo\" "
  puts "process_amend: #{sql}"
  res = con.exec(sql)
  con.close
  info = []
  sum = 0
  pid = nil
  res.each do |rec|
    yr = rec["yr"]
    pid = rec["pid"]
    oid = rec["oid"].to_i
    itemno = rec["itemno"].to_i
    amendno = rec["amendno"].to_i
    sum = rec["sum"].to_f
    datec = rec["_datecreated"]
    dateu = rec["_dateupdated"]
    if amendno > max_amend
      copy_amend(db,amendno)
      max_amend = amendno
    end
    update_amend(db,yr,pid,oid,itemno,amendno,sum,datec,dateu)
    sum = 0
  end
end

db = ARGV[0]
if db.nil?
  puts "usage: ./002-get-amend-budget.rb <DBNAME>\n"
  exit(0)
end

budget = populate_amend(db)
amend = process_amend(db)
