#!/usr/bin/ruby

require_relative 'tuc-utils'
require 'pg'
require 'pry'

def save_budget_plan(proj,info)
  proj = proj.gsub('S&D','SANDD')
  log = open("BUDGET-PLAN/NR/#{proj}","a")
  log.write("#{info}\n")
  log.close
end

def init_info(n)
  info = [n,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
end

def get_info(p,row,col)
  info = []
  (col..col+21).each do |c|
    d = p.cell(row,c)
    info.push(d)
  end
  # Remove empty cell like HIDE COLUMN, MERGE CELL
  #info.reject!(&:empty?)
  info
end

def get_budget_plan_id(project_code)
  con = PG::Connection.connect("localhost",5432,nil,nil,"test","admin")
  sql = "SELECT id FROM budget_plan "
  sql += "WHERE project_code='#{project_code}' "
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
  puts "usage: #{$0} <XLS FILE>\n"
  exit(0)
end

fy = xls.split('.').first.split('FY').last
project_id = xls.split('/').last.upcase.split('BUDGET PLAN').first.tr(' ','')

puts "\n1) get ProjectID and FY from XLS name"
puts "xls: #{xls}"
puts "fy: #{fy}"
puts "project_id: #{project_id}"

puts "\n2) find where SEP Keyword is (row number in xls)"

# ROW 1-6
# Y01 Budget Plan: September 1, 2016 - August 31, 2017

p = Tuc.new(xls)

ref_r = ref_c = 0
ref_d = nil
ref_sep = 0    # MUST FIND WHERE SEP'17 or just SEP

cell = nil

(1..10).each do |r|
  (1..10).each do |c|
    d = p.cell(r,c)
    if d.upcase =~ /PERS/ and d.strip.length < 20
      ref_r = r
      ref_c = c
      ref_d = d
      puts "FOUND: ref_r: #{ref_r} ref_c: #{ref_c} ref_d: #{ref_d}"
    elsif d.strip.upcase =~ /SEP/ and d.strip.length < 10
      ref_sep = c
      puts "FOUND: ref_sep: #{ref_sep}"
    end
    if d =~ /\ 20\d\d/ # from - to
      cell = d
      info = d.tr(',-',' ').squeeze(' ').split(' ')
      ref_date = info.join('|')   
      puts "FOUND: ref_date: #{ref_date}"   
    end
  end
end

puts "\n3) Initialize all ObjectClass and get data for each ObjectClass"

personnel = init_info(1)
fringe = init_info(2)
travel = init_info(3)
equipment = init_info(4)
supplies = init_info(5)
contractual = init_info(6)
construction = init_info(7)
others = init_info(8)

(ref_r..ref_r+100).each do |r|
  d = p.cell(r,ref_c)
  if d.upcase =~ /PERS/ and d.length < 20
    puts "\nget PERSONNEL data"
    personnel = get_info(p,r,ref_c)
    personnel[0] = '1'
    if personnel[1] == '' # merge cell
      personnel.delete_at(1)
    end
    puts "personnel: #{personnel.join('|')}"
  elsif d.upcase =~ /FRIN/ and d.length < 20
    puts "\nget FRINGE BENEFIT data"
    fringe = get_info(p,r,ref_c)
    fringe[0] = '2'
    if fringe[1] == '' # merge cell
      fringe.delete_at(1)
    end
    puts "fringe: #{fringe.join('|')}"
  elsif d.strip.upcase =~ /TRAV/ and d.length < 20
    puts "\nget TRAVEL data"
    travel = get_info(p,r,ref_c)
    travel[0] = '3'
    if travel[1] == '' # merge cell
      travel.delete_at(1)
    end
    puts "travel: #{travel.join('|')}"
  elsif d.strip.upcase =~ /EQUIP/ and d.length < 20
    puts "\nget EQUIPMENT data"
    equipment = get_info(p,r,ref_c)
    equipment[0] = '4'
    if equipment[1] == '' # merge cell
      equipment.delete_at(1)
    end
    puts "equipment: #{equipment.join('|')}"
  elsif d.upcase =~ /SUPP/ and d.length < 12
    puts "\nget SUPPLIES data"
    obj = d.strip.upcase.gsub(/\d/,'').gsub(/\s/,'').tr('.','')
    if obj == 'SUPPLIES' or (obj =~ /SUPP/ and obj.length < 10)  
      supplies = get_info(p,r,ref_c)
      supplies[0] = '5'
      if supplies[1] == '' # merge cell
        supplies.delete_at(1)
      end
    end
    puts "supplies: #{supplies.join('|')}"
  elsif d.strip.upcase =~ /CONT/ and d.length < 20
    puts "\nget CONTRACTUAL data"
    contractual = get_info(p,r,ref_c)
    contractual[0] = '6'
    if contractual[1] == '' # merge cell
      contractual.delete_at(1)
    end
    puts "contractual: #{contractual.join('|')}"
  elsif d.strip.upcase =~ /CONS/ and d.length < 20
    puts "\nget CONSTRUCTION data"
    construction = get_info(p,r,ref_c)
    construction[0] = '7'
    if construction[1] == '' # merge cell
      construction.delete_at(1)
    end
    puts "construction: #{construction.join('|')}"
  elsif d.strip.upcase =~ /OTH/ and d.length < 20
    puts "\nget OTHERS data"
    others = get_info(p,r,ref_c)
    others[0] = '8'
    if others[1] == '' # merge cell
      others.delete_at(1)
    end
    puts "others: #{others.join('|')}"
    break
  end
end

if personnel.length > 0
  info = "#{fy}|#{project_id}|#{personnel.join('|')}"
  save_budget_plan(project_id,info)
end

if fringe.length > 0
  info = "#{fy}|#{project_id}|#{fringe.join('|')}"
  save_budget_plan(project_id,info)
end

if travel.length > 0
  info = "#{fy}|#{project_id}|#{travel.join('|')}"
  save_budget_plan(project_id,info)
end

if equipment.length > 0
  info = "#{fy}|#{project_id}|#{equipment.join('|')}"
  save_budget_plan(project_id,info)
end

if supplies.length > 0
  info = "#{fy}|#{project_id}|#{supplies.join('|')}"
  save_budget_plan(project_id,info)
end

if contractual.length > 0
  info = "#{fy}|#{project_id}|#{contractual.join('|')}"
  save_budget_plan(project_id,info)
end

if construction.length > 0
  info = "#{fy}|#{project_id}|#{construction.join('|')}"
  save_budget_plan(project_id,info)
end

if others.length > 0
  info = "#{fy}|#{project_id}|#{others.join('|')}"
  save_budget_plan(project_id,info)
end
