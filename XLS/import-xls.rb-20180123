#!/usr/bin/ruby

require_relative 'tuc-utils'
require 'pg'

def get_budget_plan_id(project_code)
  con = PG::Connection.connect("localhost",5432,nil,nil,"test","admin")
  sql = "SELECT id FROM budget_plan "
  sql += "WHERE project_code='#{project_code}' "
  puts sql
  res = con.exec(sql)
  con.close
  found = res.num_tuples
  if found > 0
    id = res[0]['id']
  else
    id = 0
  end
  id
end

def insert_detail(fiscal_year,project_code,object_class_id,amend_order,dat)
  puts "project_code: #{project_code}"
  budget_plan_id = get_budget_plan_id(project_code)
  puts "budget_plan_id: #{budget_plan_id}"
  puts "object_class_id: #{object_class_id}"
  puts "dat: #{dat}"
  #Array dat: [1.0, "Program Coordinator Ms.Janjao Rodchangphuen", 336000.0,
  #336000.0, 28000.0, 28000.0, 28000.0, 84000.0, 28000.0, 28000.0,
  #28000.0, 84000.0, 28000.0, 28000.0, 28000.0, 84000.0, 28000.0,
  #28000.0, 28000.0, 84000.0, 336000.0, 0.0]
  item = dat[0].to_i
  descr = dat[1].squeeze(' ')
  orig = dat[2]
  amend = dat[3]
  q1_sep = dat[4]
  q1_oct = dat[5]
  q1_nov = dat[6]
  q1_total = dat[7]
  q2_dec = dat[8]
  q2_jan = dat[9]
  q2_feb = dat[10]
  q2_total = dat[11]
  q3_mar = dat[12]
  q3_apr = dat[13]
  q3_may = dat[14]
  q3_total = dat[15]
  q4_jun = dat[16]
  q4_jul = dat[17]
  q4_aug = dat[18]
  q4_total = dat[19]
  total_expenses = dat[20]
  balance = dat[21]
  d = [budget_plan_id,object_class_id,item,descr,orig,
       amend_order,amend,fiscal_year,q1_sep,q1_oct,q1_nov,q1_total,
       q2_dec,q2_jan,q2_feb,q2_total,q3_mar,q3_apr,q3_may,q3_total,
       q4_jun,q4_jul,q4_aug,q4_total,total_expenses,balance]
  data = d.join("','")
  con = PG::Connection.connect("localhost",5432,nil,nil,"test","admin")
  sql = "INSERT INTO detail_plan(budget_plan_id,object_class_id,item,"
  sql += "description,original_budget,amend_order,amend_budget,fiscal_year,"
  sql += "q1_sep,q1_oct,q1_nov,q1_total,q2_dec,q2_jan,q2_feb,q2_total,"
  sql += "q3_mar,q3_apr,q3_may,q3_total,q4_jun,q4_jul,q4_aug,q4_total,"
  sql += "total_expenses,balance) VALUES ('#{data}')"
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def insert_budget_plan(pc,pn,budget,cash,carry,new,person,fringe,
travel,equip,supplies,contract,construct,other)
  con = PG::Connection.connect("localhost",5432,nil,nil,"test","admin")
  sql = "INSERT INTO budget_plan (project_code,project_name,budget_approved,"
  sql += "cash_on_hand,carry_over,newly_purpose,personnel,fringe_benefit,"
  sql += "travel,equipment,supplies,contractual,construction,other) VALUES "
  sql += "('#{pc}','#{pn}','#{budget}','#{cash}','#{carry}','#{new}',"
  sql += "'#{person}','#{fringe}','#{travel}','#{equip}','#{supplies}',"
  sql += "'#{contract}','#{construct}','#{other}') "
  puts sql
  res = con.exec(sql)
  con.close
end

xls = ARGV[0]
if xls.nil?
  puts "usage: ./import-xls.rb <XLS FILE>\n"
  exit(0)
end

p = Tuc.new(xls)

# insert into budget_plan
# ROW 1-6

# Y01 Budget Plan: September 1, 2016 - August 31, 2017
a1 = p.cell(1,1)
d = a1.split(' ')
exec_year = d[0]
datestr = d[3..5].join(' ')
fiscal_year = p.fy(datestr)

#puts "exec_uear: #{exec_year}"
#puts "datestr: #{datestr}"
#puts "fiscal_year: #{fiscal_year}"

# Project code: Project Name Understanding ... (2017) (DGMQ-NR5)
a2 = p.cell(2,1)
d = a2.split(' ')
project_code = d.last.tr('()','')
project_name = d[4..-2].join(' ')

#puts "project_code:#{project_code}"
#puts "project_name:#{project_name}"

# Budget Approved
a3 = p.cell(3,1) # Budget Approved:
c3 = p.cell(3,3) # Amount
budget_approved = c3.to_s.tr(',','').to_f

#puts "budget_approved: #{budget_approved}"

# Cash on hand
a4 = p.cell(4,1) # Cash on hand:
c4 = p.cell(4,3) # Amount
cash_on_hand = c4.to_s.tr(',','').to_f

#puts "cash_on_hand: #{cash_on_hand}"

# Carry over
a5 = p.cell(5,1) # Carry over:
c5 = p.cell(5,3) # Amount
carry_over = c5.to_s.tr(',','').to_f

#puts "carry_over: #{carry_over}"

# Newly purpose
a6 = p.cell(6,1) # Newly purpose:
c6 = p.cell(6,3) # Amount
newly_purpose = c6.to_s.tr(',','').to_f

#puts "newly_purpose: #{newly_purpose}"

# Amend order shown in cell D8
info = p.cell(8,4)
amend_order = info[0]
puts "amend_order: #{amend_order}"

# Allocated budget by Object Class 1-8
# first find which row number these 1. - 8.
col_a = p.column(1)

n = 0
personnel = fringe_benefit = travel = equipment = 0
supplies = contractual = construction = other = 0 
object_class = 0
start = false
col_a.each do |c|
  n += 1
  if c =~ /\d\.\ /
    if c =~ /1\.\ / # PERSONNEL
      personnel = p.row(n)[2]
      puts "personnel: #{personnel}"
      start = true
      object_class = 1
    elsif c =~ /2\.\ / # FRINGE BENEFIT
      fringe_benefit = p.row(n)[2]
      puts "fringe_benefit: #{fringe_benefit}"
      object_class = 2
    elsif c =~ /3\.\ / # TRAVEL
      travel = p.row(n)[2]
      puts "travel: #{travel}"
      object_class = 3
    elsif c =~ /4\.\ / # EQUIPMENT
      equipment = p.row(n)[2]
      puts "equipment: #{equipment}"
      object_class = 4
    elsif c =~ /5\.\ / # SUPPLIES
      supplies = p.row(n)[2]
      puts "supplies: #{supplies}"
      object_class = 5
    elsif c =~ /6\.\ / # CONTRACTUAL
      contractual = p.row(n)[2]
      puts "contractual: #{contractual}"
      object_class = 6
    elsif c =~ /7\.\ / # CONSTRUCTION
      construction = p.row(n)[2]
      puts "construction: #{construction}"
      object_class = 7
    elsif c =~ /8\.\ / # OTHER
      other = p.row(n)[2]
      puts "other: #{other}"
      object_class = 8
    end
  elsif c.to_s =~ /\d\.0/
    dat = p.row(n)
    insert_detail(fiscal_year,project_code,object_class,amend_order,dat)
  end
end

# Insert budget_plan
puts "INSERT data INTO budget_plan"
insert_budget_plan(project_code,project_name,budget_approved,cash_on_hand,\
carry_over,newly_purpose,personnel,fringe_benefit,travel,equipment,supplies,\
contractual,construction,other)
