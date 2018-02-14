#!/usr/bin/ruby

require_relative 'thousands'
require 'pg'
require 'pry-byebug'

# REPORT-03 LIST Detail for each project

def get_project_name(id)
  con = PG::Connection.connect("localhost",5432,nil,nil,"aaa","admin")
  sql = "SELECT name "
  sql += "FROM projects "
  sql += "WHERE id='#{id}' "
  res = con.exec(sql)
  con.close
  name = "NA"
  name = res[0]['name'] if res.num_tuples > 0
end

def f2(f)
  f = "%.2f" % f.to_f
  f.thousands
end

def get_obj_class(id)
  objc = [
            "",
            "1. Personnel",
            "2. Fringe Benefits",
            "3. Travel",
            "4. Equipment",
            "5. Supplies",
            "6. Contractual",
            "7. Construction",
            "8. Other"
          ]
  objc[id.to_i]
end

def find_plan_detail(rnr,code)
  code = code.gsub(/\&/,'AND')
  code = code.gsub(/\-MOPH/,'')
  code = code.gsub(/OH-WFD/,'OHWFD')
  path = "XLS/BUDGET-PLAN/#{rnr}/*"
  entries = Dir.glob(path)
  fn = 'NA'
  entries.each do |f|
    next if f !~ /#{code}/
    if code =~ /OH$/
      next if f =~ /WFD/
    end
    fn = f
  end
  fn
end

def gen_html(rnr,code,pname,info)
  path = (rnr == 'R') ? "Research > " : "Non-Research > "
  fp = open("#{code}.html","w")
  fp.write("<html>\n")
  fp.write("<body>\n")
  fp.write("<h3>#{path}#{code}<h3>\n")
  fp.write("<h3><font color='green'>Project: #{pname}</font></h3>\n<hr>\n")
  fp.write("<table border='1' style='margin-top:20px'>\n")
  fp.write("<tr>\n")
  fp.write("  <th width='15%'>Fiscal Year</th><th width='15%'>Item</th>")
  fp.write("  <th width='15%'>Approved Budget</th>")
  fp.write("  <th width='10%'>Q1</th><th width='10%'>Q2</th>")
  fp.write("  <th width='10%'>Q3</th><th width='10%'>Q4</th>")
  fp.write("<tr>\n")
  total = 0
  info.each do |i|
    total += i[3].to_s.to_f
    fp.write("<tr>\n")
    fp.write("  <th>FY#{i[0]}</th><td>#{get_obj_class(i[2])}</td>")
    fp.write("  <td align='right'>#{f2(i[3])}</td>")
    fp.write("  <td align='right'>#{f2(i[4])}</td>")
    fp.write("  <td align='right'>#{f2(i[5])}</td>")
    fp.write("  <td align='right'>#{f2(i[6])}</td>")
    fp.write("  <td align='right'>#{f2(i[7])}</td>\n")      
    fp.write("<tr>\n")
  end
  fp.write("<tr bgcolor='lightblue'>\n")
  fp.write("  <th></th><th align='right'>Total</th><th align='right'>#{f2(total)}</th>")
  fp.write("  <th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th>\n")
  fp.write("<tr>\n")

  fp.write("</table>\n")
  fp.write("<p><button onclick='history.back()'>Back</button>\n")
  fp.write("</body>\n")
  fp.write("</html>\n")
  fp.close
end

def generate_detail(rnr,id,sid,code)
  target = find_plan_detail(rnr,code)
  src = open(target).readlines
  pname = get_project_name(id)

  if pname == 'NA'
    puts "rnr: #{rnr} id: #{id} sid: #{sid} code: #{code}"
    exit
  end

  info = []
  src.each do |line|
    f = line.chomp.split('|')
    fy = f[0][2..3]
    pid = f[1]
    objc = f[2]
    bgt = f[3]
    q1 = f[7]
    q2 = f[11]
    q3 = f[15]
    q4 = f[19]  
    info.push([fy,pid,objc,bgt,q1,q2,q3,q4])
  end
  gen_html(rnr,code,pname,info)
end

src = open("RNR").readlines
src.each do |line|
  f = line.chomp.split('|')
  rnr = f[0]
  pid = f[1]
  sid = f[2]
  code = f[3]
  generate_detail(rnr,pid,sid,code)
end
