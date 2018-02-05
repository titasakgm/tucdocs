#!/usr/bin/ruby

require 'roo-xls'
require 'pg'
require 'pry'

def save_data(proj,objectclass,msgs)
  fp = open("/tmp/#{proj}","a")
  fp.write("\n#{proj}:#{objectclass}\n")
  fp.write(msgs.join("\n"))
  fp.close
end

def f2(f)
  f2 = "%0.2f" % f.to_f
  f2.to_f
end

def get_data(xls,row,ref_bud,ref_sep,debug)
  if debug == 1
    binding.pry
  end
  approved_budget = xls.cell(row,ref_bud)
  puts "approved_budget: #{approved_budget}"
  data = []
  (ref_sep..ref_sep+16).each do |c|
    s = xls.cell(row,c)
    msg = s.to_s.strip
    if msg.to_f > 0.0
      msg = f2(msg)
    end
    data.push(msg)
  end
  data.insert(0,approved_budget)
  data
end

def update_progress(proj,xls,hdr_row,ref_bud,ref_sep,debug)

  # Find ObjectClass
  # personnel,fringe,travel,equip,supplies,contract,construct,other
  puts "hdr_row: #{hdr_row} #{hdr_row.class}"
  puts "ref_bud: #{ref_bud} #{ref_bud.class}"
  puts "ref_sep: #{ref_sep} #{ref_sep.class}"

  processed = []
  (hdr_row+1..hdr_row+100).each do |r|
    (1..ref_bud-1).each do |c|
      s = xls.cell(r,c)
      next if s.to_s.length > 19
      if s.to_s.to_s.upcase =~ /PERS/ and !processed.include?('PERS') and s.to_s.strip.length < 16
        puts "PERSONNEL: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        personnel = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('PERS')
        save_data(proj,'PERSONNEL',personnel)
      elsif s.to_s.upcase =~ /FRIN/ and !processed.include?('FRIN') and s.to_s.strip.length < 20
        puts "FRINGE: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        fringe = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('FRIN')
        save_data(proj,'FRINGE BENEFIT',fringe)
      elsif s.to_s.upcase =~ /TRAV/ and !processed.include?('TRAV') and s.to_s.strip.length < 10
        puts "TRAVEL: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        travel = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('TRAV')
        save_data(proj,'TRAVEL',travel)
      elsif s.to_s.upcase =~ /SUPP/ and !processed.include?('SUPP') and s.to_s.strip.length < 15
        puts "SUPPLIES: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        supplies = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('SUPP')
        save_data(proj,'SUPPLIES',supplies)
      elsif s.to_s.upcase =~ /EQUIP/ and !processed.include?('EQUIP') and s.to_s.strip.length < 17
        puts "EQUIPMENT: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        equipt = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('EQUIP')
        save_data(proj,'EQUIPMENT',equipt)
      elsif s.to_s.upcase =~ /CONTR/ and !processed.include?('CONTR')and s.to_s.strip.length < 17
        puts "CONTRACT: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        contract = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('CONTR')
        save_data(proj,'CONTRACT',contract)
      elsif s.to_s.upcase =~ /CONST/ and !processed.include?('CONST') and s.to_s.strip.length < 17
        puts "CONSTRUCTION: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        construct = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('CONST')
        save_data(proj,'CONSTRUCTION',construct)
      elsif s.to_s.upcase =~ /OTHER/ and !processed.include?('OTH') and s.to_s.strip.length < 10
        puts "OTHER: [#{s}] (#{s.strip.length}) row: #{r} col: #{c}"
        other = get_data(xls,r,ref_bud,ref_sep,debug)
        processed.push('OTH')
        save_data(proj,'OTHER',other)
      end
    end
  end

  exit

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
   
f = ARGV[0]
sheet = ARGV[1].to_s.to_i
hdr_row = ARGV[2].to_s.to_i
hdr = ARGV[3]

if hdr.nil?
  puts "usage: #{$0} <XLS FILE> <SHEET> <HDR_ROW> <HDR>\n"
  exit(0)
end

puts "f: #{f}"
puts "sheet: #{sheet}"
puts "hdr_row: #{hdr_row}"
puts "hdr: #{hdr}"

proj = f.split('/').last.gsub(/\ \-/,'-').gsub(/\-\ /,'-').split(' ').first.upcase
puts "proj: #{proj}"

# Analyse hdr
ref_sep = 0
ref_bal = 0

a = hdr.split(',')
a.each do |h|
  if h.upcase =~ /SEP/
    ref_sep = h.split(':').first.to_i
  elsif h.upcase =~ /BALANCE/ or h.upcase =~ /DIFF/
    ref_bal = h.split(':').first.to_i
    break
  end
end

puts "FILE: #{f}"
puts "ref_sep: #{ref_sep} ref_bal: #{ref_bal} ref_bal-ref_sep: #{ref_bal-ref_sep}\n" 

# check header for original approved == ref_sep-1 or ref_sep-2 or ref_sep-3 or ref_sep-4
ref_bud = 0
n = 0
while n < 4
  n += 1

  puts n
  puts a[ref_sep-n]

  if a[ref_sep-n].upcase =~ /BUD/ or a[ref_sep-1].upcase =~ /APP/
    puts "-->n: #{n}"
    puts "-->a[ref_sep-n]: #{a[ref_sep-n]}"
    ref_bud = a[ref_sep-n].split(':').first.to_i
    puts "-->ref_bud: #{ref_bud}"
    break
  end
end

#puts "hdr_row: #{hdr_row}"
#puts "ref_bud: #{ref_bud}"
#puts "ref_sep: #{ref_sep}"


# get all categories with sheet,hdr_row,ref_bud,ref_sep

xls = Roo::Spreadsheet.open(f)
xls.default_sheet = xls.sheets[sheet]

debug = 0
update_progress(proj,xls,hdr_row,ref_bud,ref_sep,debug)
