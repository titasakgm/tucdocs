#!/usr/bin/ruby

require 'time'
require 'pg'

def get_spent(project_code,classitem)
  con = PG::Connection.connect("localhost",5432,nil,nil,"test","admin")
  sql = "SELECT total "
  sql += "FROM v_spent "
  sql += "WHERE project_code='#{project_code}' AND classitem='#{classitem}' "
  res = con.exec(sql)
  con.close
  return res[0]['total'] || 0
end

def get_yyyymm(datestr)
  return datestr if datestr !~ /00:00:00/
  dt = DateTime.strptime(datestr,"%m/%d/%y %H:%M:%S")
  yyyymm = dt.strftime("%Y%m")
end

src = open("Spend.csv").readlines

h = {}
n = 0
project_code = nil
class_item = nil
total = 0
src.each do |line|
  n += 1
  next if n == 1
  f = line.chomp.tr('"','').split(',')
  yyyymm = get_yyyymm(f[7])
  if project_code.nil?
    project_code = f[1]
  end
  class_item = "#{f[3]}#{f[4]}"
  total = f[8].to_i
  if !h.include?(class_item)
    h[class_item] = total
  else
    h[class_item] += total
  end
end

h.sort.each do |k,v|
  v_total = get_spent(project_code,k)
  puts "#{k} => #{v} : v_total: #{v_total}"
end

