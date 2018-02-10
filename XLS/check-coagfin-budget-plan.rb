#!/usr/bin/ruby

require 'pg'
require 'colorize'

def f2(f)
 "%.2f" % f.to_s.to_f
end

def get_project_subproject_id(code)

  # FIX CARECOACH-PIF > CARE-COACH-PIF 
  code = code.sub('CARECOACH','CARE-COACH')

  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT proj_id,subp_id "
  sql += "FROM v_project_subprojectx "
  sql += "WHERE code LIKE '#{code}%' "
  sql += "LIMIT 1"
  puts "get_project:sql: #{sql}"
  res = con.exec(sql)
  con.close  
  found = res.num_tuples
  info = ['NA','NA']
  if found > 0
    proj_id = res[0]['proj_id']
    subp_id = res[0]['subp_id']
    info = [proj_id,subp_id]
  end
  info
end

def get_max_coagyear(code)
  info = get_project_subproject_id(code)
  proj_id = info[0]
  subp_id = info[1]
  #puts "proj_id: #{proj_id} subp_id: #{subp_id}"
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT max(coagyear) as max "
  sql += "FROM budgets "
  sql += "WHERE project_id=#{proj_id} AND subproject_id=#{subp_id} "
  #puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
  res[0]['max'].to_s.to_i or -1
end

def check_coagfin(code,objc,bgt)
  bgt = bgt.to_s.to_f
  max_coagyear = get_max_coagyear(code)
  info = get_project_subproject_id(code)
  proj_id = info[0]
  subp_id = info[1]
  #puts "max_coagyear: #{max_coagyear} proj_id: #{proj_id} subp_id: #{subp_id}"
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT sum(total) as budget "
  sql += "FROM budgets "
  sql += "WHERE coagyear='#{max_coagyear}' AND project_id='#{proj_id}' "
  sql += "AND subproject_id='#{subp_id}' AND object_class_id='#{objc}' "  
  res = con.exec(sql)
  con.close
  approved_budget = res[0]['budget'].to_s.to_f
  if f2(approved_budget) == f2(bgt)
    puts "#{code}: CoAgFin: " + approved_budget.to_s.green + "<=> Budget Plan: " + bgt.to_s.green
    return true
  else
    puts "#{code}: CoAgFin: " + approved_budget.to_s.red + "<=> Budget Plan: " + bgt.to_s.red
    return false
  end
end

def get_plan(plan)
  fp = open(plan).readlines
  fp.each do |line|
    d = line.chomp.split('|')
    code = d[1]
    objc = d[2]
    bgt = d[3].to_s.to_f
    puts "code: #{code} objc: #{objc} bgt: #{bgt}"
    max_coagyear = get_max_coagyear(code)
    puts "max coagyear: #{max_coagyear}"
    flag = check_coagfin(code,objc,bgt)
  end
end

entries = Dir.glob("BUDGET-PLAN/*/**")
entries.sort.each do |plan|
  code = plan.split('/').last
  puts "plan: #{plan} code: #{code}"
  xls = get_plan(plan)
end

