#!/usr/bin/ruby

require 'pg'
require 'pry'

def replace_single_quote(arr)
  (0...arr.length).each do |n|
    if arr[n].to_s.include?("'")
      binding.pry
      arr[n] = arr[n].gsub("'","''")
    end
  end
  arr
end

def insert_budget(f)
  # f[20] created_at => NULL::timestamp' if created_at.nil?
  # f[22] updated_at => NULL::timestamp' if updated_at.nil?

  f = replace_single_quote(f)
  
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "INSERT INTO budgets (coagyear,project_id,subproject_id,object_class_id,itemno,amendno,"
  sql += "itemdescription,itemdescriptiond,restrict,cashonhand,carryover,new,total,unit,qty,"
  sql += "op1,op2,op3,op4,op5,created_at,user_created,updated_at,user_updated) "
  sql += "VALUES ('#{f[0]}','#{f[1]}','#{f[2]}','#{f[3]}',"
  sql += "'#{f[4]}','#{f[5]}','#{f[6]}','#{f[7]}','#{f[8]}',"
  sql += "'#{f[9]}','#{f[10]}','#{f[11]}','#{f[12]}','#{f[13]}',"
  sql += "'#{f[14]}','#{f[15]}','#{f[16]}','#{f[17]}','#{f[18]}','#{f[19]}',"

  if f[20].nil? or f[22].nil? or f[20].to_s.length == 0 or f[22].to_s.length == 0 
    sql += "NULL,'#{f[21]}',NULL,'#{f[23]}') "
  else
    sql += "'#{f[20]}','#{f[21]}','#{f[22]}','#{f[23]}') "
  end

  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_budget_dup(coagyear,proj_id,subp_id,objc_id,itemno,amendno)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM budgets "
  sql += "WHERE coagyear='#{coagyear}' AND project_id='#{proj_id}' "
  sql += "AND subproject_id='#{subp_id}' AND object_class_id='#{objc_id}' "
  sql += "AND itemno='#{itemno}' AND amendno='#{amendno}' "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def get_budget(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT * "
  sql += "FROM \"Budget\" "
  res = con.exec(sql)
  con.close
  res.each do |rec|
    coagyear = rec['CoAgYear']
    code_proj = rec['ProjectID']
    code_subp = rec['SubprojectID']
    code_objc = rec['ObjectClassID']
    itemno = rec['ItemNo']
    amendno = rec['AmendNo']
    item = rec['ItemDescription']
    itemd = rec['ItemDescriptionD']
    restrict = rec['Restrict'].to_s.to_f
    cashonhand = rec['CashOnHand'].to_s.to_f
    carryover = rec['CarryOver'].to_s.to_f
    new = rec['New'].to_s.to_f
    total = rec['Total'].to_s.to_f
    unit = rec['Unit']
    qty = rec['Qty'].to_s.to_f
    op1 = rec['OP1'].to_s.to_f
    op2 = rec['OP2'].to_s.to_f
    op3 = rec['OP3'].to_s.to_f
    op4 = rec['OP4'].to_s.to_f
    op5 = rec['OP5'].to_s.to_f
    created_at = rec['_datecreated']
    user_created = rec['_usercreated'].to_s.to_i
    updated_at = rec['_dateupdated']
    user_updated = rec['_userupdated'].to_s.to_i

    puts "code_proj: #{code_proj}"
    puts "code_subp: #{code_subp}"
    puts "code_objc: #{code_objc}"

    proj_id = get_project_id(code_proj)
    subp_id = get_subproject_id(code_subp)
    objc_id = get_object_class_id(code_objc)

    puts proj_id,subp_id,objc_id
    dup = check_budget_dup(coagyear,proj_id,subp_id,objc_id,itemno,amendno)
    puts "dup: #{dup}"
    if !dup
      flds = [coagyear,proj_id,subp_id,objc_id,itemno,amendno,item,itemd,restrict,cashonhand,carryover,new,total]
      flds += [unit,qty,op1,op2,op3,op4,op5,created_at,user_created,updated_at,user_updated]
      insert_budget(flds)
    else
      puts "***** DUP: #{db}: coagyear: #{coagyear} proj_id: #{proj_id} subp_id: #{subp_id} objc_id: #{objc_id} (#{itemno},#{amendno})"
    end
  end
end

def insert_staff(userid,pass)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "INSERT INTO staffs (userid,password) "
  sql += "VALUES ('#{userid}','#{pass}') "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_user_dup(userid,pass)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM staffs "
  sql += "WHERE userid='#{userid}' AND password='#{pass}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def get_user(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT * "
  sql += "FROM \"User\" "
  puts "sql:#{sql}"
  res = con.exec(sql)
  con.close
  res.each do |rec|
    userid = rec['UserId']
    pass = rec['Password']

    puts "#{userid} #{pass}"

    dup = check_user_dup(userid,pass)
    puts "dup: #{dup}"
    if !dup
      insert_staff(userid,pass) # Table users in PostgreSQL DUP with system table => change to staffs
    else
      puts "***** DUP: #{db}: userid: #{userid} pass: #{pass}"
    end
  end
end

def insert_project_subproject(coagyear,proj_id,subp_id)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "INSERT INTO project_subprojects (coagyear,project_id,subproject_id) "
  sql += "VALUES ('#{coagyear}','#{proj_id}','#{subp_id}') "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_project_subproject_dup(coagyear,proj_id,subp_id)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM project_subprojects "
  sql += "WHERE coagyear='#{coagyear}' AND project_id='#{proj_id}' AND subproject_id='#{subp_id}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def get_project_subproject(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT * "
  sql += "FROM \"ProjectSubproject\" "
  res = con.exec(sql)
  con.close
  res.each do |rec|
    coagyear = rec['CoAgYear']
    code_proj = rec['ProjectID']
    code_subp = rec['SubprojectID']
    pc = rec['ProjectCoordinator']

    proj_id = get_project_id(code_proj)
    subp_id = get_subproject_id(code_subp)

    puts coagyear,proj_id,subp_id

    dup = check_project_subproject_dup(coagyear,proj_id,subp_id)
    puts "dup: #{dup}"
    if !dup
      insert_project_subproject(coagyear,proj_id,subp_id)
    else
      puts "***** DUP: #{db}: coagyear: #{coagyear} proj_id: #{proj_id} subp_id: #{subp_id}"
    end
  end
end

def insert_subproject(code,name)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "INSERT INTO subprojects (code,name) "
  sql += "VALUES ('#{code}','#{name}') "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_subproject_dup(code,name)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT code,name "
  sql += "FROM subprojects "
  sql += "WHERE code='#{code}' AND name='#{name}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def get_object_class_id(code)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM object_classes "
  sql += "WHERE code='#{code}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  id = (found > 0) ? res[0]['id'] : 0
end

def get_subproject_id(code)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM subprojects "
  sql += "WHERE code='#{code}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  id = (found > 0) ? res[0]['id'] : 0
end

def get_project_id(code)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM projects "
  sql += "WHERE code='#{code}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  id = (found > 0) ? res[0]['id'] : 0
end

def get_subproject(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT * "
  sql += "FROM \"Subproject\" "
  res = con.exec(sql)
  con.close
  subprojects = []
  res.each do |rec|
    code = rec['SubprojectID']
    name = rec['SubprojectName']

    dup = check_subproject_dup(code,name)
    puts "dup: #{dup}"
    if !dup
      insert_subproject(code,name)
    else
      puts "***** DUP: #{db}: code: #{code} name: #{name}"
    end
  end
  subprojects
end

def insert_project(code,name,coagwith,research,program_id,tc)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "INSERT INTO projects (code,name,coagwith,research,program_id,"
  sql += "technicalcoordinator) VALUES ('#{code}','#{name}','#{coagwith}',"
  sql += "'#{research}','#{program_id}','#{tc}') "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_project_subproject_dup(coagyear,proj_id,subp_id)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT id "
  sql += "FROM project_subprojects "
  sql += "WHERE coagyear='#{coagyear}' AND project_id='#{proj_id}' AND subproject_id='#{subp_id}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def check_project_dup(code,name)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT code,name "
  sql += "FROM projects "
  sql += "WHERE code='#{code}' AND name='#{name}' "
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  flag = (found > 0) ? true : false
end

def get_project(db)
  con = PG::Connection.connect("localhost",5432,nil,nil,"#{db}","admin")
  sql = "SELECT * "
  sql += "FROM \"Project\" "
  res = con.exec(sql)
  con.close
  res.each do |rec|
    code = rec['ProjectID']
    name = rec['ProjectName']
    coagwith = rec['CoAgWith']
    research = rec['Research']
    program_id = rec['ProgramID']
    tc = rec['TechnocalCoordinator']

    research = (research == 'N') ? 'f' : 't'
    program_id = program_id.to_i + 1

    dup = check_project_dup(code,name)
    puts "dup: #{dup}"
    if !dup
      insert_project(code,name,coagwith,research,program_id,tc)
    else
      puts "***** DUP: #{db}: code: #{code} name: #{name}"
    end
  end  
end

dbs = open("tuc-16-41").readlines

n = 0
dbs.each do |line|
  n += 1
  db = line.chomp
  puts "#{n}: #{db}"

  staffs = get_user(db)
  projs = get_project(db)
  subprojs = get_subproject(db)
  projsubs = get_project_subproject(db)
  budgets = get_budget(db)
  # amends = get_amendment(db)
  # bamends = get_budget_amend(db)
  # receives = get_receive(db)
  # spends = get_spend(db)
end
