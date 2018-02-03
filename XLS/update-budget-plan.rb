#!/usr/bin/ruby

require 'pg'

def f2(f)
  f2 = "%0.2f" % f.to_f
  f2.to_f
end

def update_original_plan(proj,d)

  q1 = 5
  # find pq1_sep for d[4] or d[5]
  # 2018|CEI-NR|1|338400.0|28000.0|5600.0|12600.0|12600.0|30800.0|
  if d[4].to_f + d[5].to_f + d[6].to_f == d[7].to_f
    q1 = 4
  end
  pq1_total = d[q1+3].to_f
  pq2_total = d[q1+7].to_f
  pq3_total = d[q1+11].to_f
  pq4_total = d[q1+15].to_f
  pq1x4 = pq1_total + pq2_total + pq3_total + pq4_total

  pq1_1 = d[q1].to_s.to_f
  pq1_2 = d[q1+1].to_s.to_f
  pq1_3 = d[q1+2].to_s.to_f
  pq1_4 = d[q1+3].to_s.to_f
  pq2_1 = d[q1+4].to_s.to_f
  pq2_2 = d[q1+5].to_s.to_f
  pq2_3 = d[q1+6].to_s.to_f
  pq2_4 = d[q1+7].to_s.to_f
  pq3_1 = d[q1+8].to_s.to_f
  pq3_2 = d[q1+9].to_s.to_f
  pq3_3 = d[q1+10].to_s.to_f
  pq3_4 = d[q1+11].to_s.to_f
  pq4_1 = d[q1+12].to_s.to_f
  pq4_2 = d[q1+13].to_s.to_f
  pq4_3 = d[q1+14].to_s.to_f
  pq4_4 = d[q1+15].to_s.to_f

  original = d[3].to_f
  bal = original - pq1x4

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
  proj = 'DGHP-OH-WFD' if proj == 'DGHP-OHWFD'
  proj = 'DGHP-EOC' if proj == 'DGHP-MOPH-EOC'

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
    if f2(orig) == f2(budget.to_f) # FIX 234103.67 VS 234103.669999999999998
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
      puts "ERROR: #{proj} #{line} #{amt} not match ORIGINAL"
      exit
    end
  end
end
   
entries = Dir.glob("BUDGET-PLAN/**/*")

entries.each do |f|
  proj = f.upcase
  process(f)
end
