#!/usr/bin/ruby

require 'pg'

def f2(f)
  f2 = "%0.2f" % f.to_f
  f2.to_f
end

def update_original_plan(proj,d)
  pq1_total = d[8].to_f
  pq2_total = d[12].to_f
  pq3_total = d[16].to_f
  pq4_total = d[20].to_f
  pq1_4 = pq1_total + pq2_total + pq3_total + pq4_total

  pq1_1 = d[6].to_s.to_f
  pq1_2 = d[7].to_s.to_f
  pq1_3 = d[8].to_s.to_f
  pq1_4 = d[9].to_s.to_f
  pq2_1 = d[10].to_s.to_f
  pq2_2 = d[11].to_s.to_f
  pq2_3 = d[12].to_s.to_f
  pq2_4 = d[13].to_s.to_f
  pq3_1 = d[14].to_s.to_f
  pq3_2 = d[15].to_s.to_f
  pq3_3 = d[16].to_s.to_f
  pq3_4 = d[17].to_s.to_f
  pq4_1 = d[18].to_s.to_f
  pq4_2 = d[19].to_s.to_f
  pq4_3 = d[6].to_s.to_f
  pq4_4 = d[6].to_s.to_f

  original = d[3].to_f
  bal = original - pq1_4

  con = PG::Connection.connect("localhost",5432,nil,nil,"tuc-mon","admin")
  sql = "UPDATE progress SET pq1_sep=#{pq1_1},pq1_oct=#{pq1_2},pq1_nov=#{pq1_3},pq1_total=#{pq1_4},"
  sql += "pq2_dec=#{pq2_1},pq2_jan=#{pq2_2},pq2_feb=#{pq2_3},pq2_total=#{pq2_4},"
  sql += "pq3_mar=#{pq3_1},pq3_apr=#{pq3_2},pq3_may=#{pq3_3},pq3_total=#{pq3_4},"
  sql += "pq4_jun=#{pq4_1},pq4_jul=#{pq4_2},pq4_aug=#{pq4_3},pq4_total=#{pq4_4},"
  sql += "spend_total=#{pq1_4},balance=#{bal} "
  sql += "WHERE projectid='#{proj}' AND amendno='0' AND objectclassid='#{d[2]}' "
  puts "sql: #{sql}"
  res = con.exec(sql)
  con.close
end

def check_original(proj,obj,budget)
  con = PG::Connection.connect("localhost",5432,nil,nil,"tuc-mon","admin")
  sql = "SELECT original "
  sql += "FROM progress "
  sql += "WHERE projectid='#{proj}' AND objectclassid='#{obj}' " 
  res = con.exec(sql)
  con.close
  if res.num_tuples == 0
    return false
  else
    orig = res[0]['original'].to_s.to_f
    if f2(orig) == f2(budget.to_f)
      return true
    else
      return false
    end
  end
end

def process(f)
  info = open(f).readlines
  info.each do |line|
    d = line.chomp.split('|')
    proj = d[1]
    cat = d[2]
    amt = d[3].to_s.to_f
    if amt == 0
      puts "line: #{line}"
      puts "original == 0 DO NOTHING!"
      next
    end
    flag = check_original(proj,cat,amt)
    if flag
      update_original_plan(proj,d)
    else
      puts "ERROR: #{proj} #{line} not match ORIGINAL"
      exit
    end
  end
end
   
entries = Dir.glob("BUDGET-PLAN/**/*")

entries.each do |f|
  proj = f.upcase
  process(f)
end

