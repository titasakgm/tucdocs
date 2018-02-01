#!/usr/bin/ruby

require 'pg'

# get Amendment data for latest CoAgYear
# update current in tuc-mon:progress

def get_amend(db,coagyear)
  # CoAgYear|ProjectID|SubprojectID|AmendNo|AmendRefNo|AmendDate|CashOnHand|Carryover|New|Gain

  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT \"CoAgYear\" AS coagyear,\"AmendNo\" as amendno,"
  sql += "\"CashOnHand\" AS cashonhand,\"Carryover\" AS carryover,\"New\" AS new, "
  sql += "\"Gain\" AS gain "
  sql += "FROM \"Amendment\" "
  sql += "WHERE \"CoAgYear\"='#{coagyear}' AND \"AmendNo\" > '0' "
  sql += "ORDER BY \"CoAgYear\",\"AmendNo\" "
  res = con.exec(sql)
  con.close
  amend = []
  found = res.num_tuples
  if found > 0
    res.each do |rec|
      a = rec['coagyear']
      b = rec['amendno']
      c = rec['cashonhand']
      d = rec['carryover']
      e = rec['new']
      f = rec['gain']
      amend.push([a,b,c,d,e,f])
    end
  end
  amend
end

def get_progress_info()
  con = PG::Connection.connect("localhost",5432,nil,nil,"tuc-mon","admin")
  sql = "SELECT distinct(coagyear),projectid "
  sql += "FROM progress "
  sql += "ORDER BY projectid "
  res = con.exec(sql)
  con.close
  info = []
  res.each do |rec|
    projectid = rec['projectid'].downcase
    coagyear = rec['coagyear']
    info.push([projectid,coagyear])
  end
  info
end

info = get_progress_info()
info.each do |p|
  proj = p[0]
  coagyear = p[1]
  amend = get_amend(proj,coagyear)
  if amend.length == 0
    puts "No Amendment project:#{proj.upcase} CoAgYear:#{coagyear} "
  else
    amend.each do |a|
      puts a.join('=')
    end
  end
end
