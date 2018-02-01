#!/usr/bin/ruby

# Update DB:tuc-mon TABLE:progress
# 1 Initial LATEST CoAgYear,AmendNo -> original
# 2 AmendNo > 0 -> current
# 3 Spend for each ObjectClassID, each Quarter -> spend_q1 .. spend_q4 -> sum (q1-q4) to spend_total
# 4 Calculate progress_q1 .. progress_q4 and progress_total (spend_total * 100 / original)

require 'pg'

def check_dup_initial(coagyear,proj,objectclassid)
  con = PG::Connection.connect("localhost",5432,nil,nil,"tuc-mon","admin")
  sql = "SELECT coagyear "
  sql += "FROM progress "
  sql += "WHERE coagyear='#{coagyear}' AND projectid='#{proj}' "
  sql += "AND amendno='0' AND objectclassid='#{objectclassid}' "
  res = con.exec(sql)
  con.close
  return (res.num_tuples == 0) ? false : true
end

def insert_initial(coagyear,proj,amendno,objectclassid,cashonhand,new,total,original,current)
  con = PG::Connection.connect("localhost",5432,nil,nil,"tuc-mon","admin")
  sql = "INSERT INTO progress (coagyear,projectid,amendno,objectclassid,"
  sql += "cashonhand,new,total,original,current) "
  sql += "VALUES ('#{coagyear}','#{proj.upcase}','#{amendno}','#{objectclassid}','#{cashonhand}',"
  sql += "'#{new}','#{total}','#{original}','#{current}') "
  puts "sql:insert: #{sql}"
  res = con.exec(sql)
  con.close
end

def insert_progress(coagyear,proj,info)
  amendno = info[0]
  objectclassid = info[1]
  cashonhand = info[2].to_f
  new = info[3].to_f
  total = info[4].to_f
  original = current = total
  flag = check_dup_initial(coagyear,proj,objectclassid)
  if !flag
    insert_initial(coagyear,proj,amendno,objectclassid,cashonhand,new,total,original,current)
  else
    puts "initial already inserted!"
  end
end

def get_latest_coagyear(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT max(\"CoAgYear\") as coagyear "
  sql += "FROM \"Budget\" "
  res = con.exec(sql)
  con.close
  max_coagyear = res[0]['coagyear']
end

def get_original_budget(db,max_coagyear)
  # amendno,objectclassid,carryover,new,total
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"AmendNo\" AS amendno,\"ObjectClassID\" as objectclassid,sum(to_number(\"CashOnHand\",'9999999.99')) AS cashonhand,"
  sql += "sum(to_number(\"New\",'9999999.99')) AS new,sum(to_number(\"Total\",'9999999.99')) AS total "
  sql += "FROM \"Budget\" "
  sql += "WHERE \"CoAgYear\"='#{max_coagyear}' "
  sql += "AND \"AmendNo\"='0' "
  sql += "GROUP BY \"AmendNo\",\"ObjectClassID\" "
  sql += "ORDER BY \"AmendNo\",\"ObjectClassID\" "
  res = con.exec(sql)
  con.close
  info = []
  info[1] = ['0','1','0.0','0.0','0.0']
  info[2] = ['0','2','0.0','0.0','0.0']
  info[3] = ['0','3','0.0','0.0','0.0']
  info[4] = ['0','4','0.0','0.0','0.0']
  info[5] = ['0','5','0.0','0.0','0.0']
  info[6] = ['0','6','0.0','0.0','0.0']
  info[8] = ['0','8','0.0','0.0','0.0']

  res.each do |rec|
    a = rec['amendno']
    b = rec['objectclassid']
    c = rec['cashonhand']
    d = rec['new']
    e = rec['total']
    dat = [a,b,c,d,e]
    info[b.to_i] = dat
  end
  info
end

proj = ARGV[0]
if proj.nil?
  puts "usage: #{$0} <PROJECT ID>\n"
  exit(0)
end

db = proj.downcase

max_coagyear = get_latest_coagyear(db)
puts "max_coagyear: #{max_coagyear}"

original = get_original_budget(db,max_coagyear)
puts "original: #{original}"

[1,2,3,4,5,6,8].each do |n|
  puts "original: #{original[n].join('-')}"
  insert_progress(max_coagyear,db,original[n])
end
