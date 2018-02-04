#!/usr/bin/ruby

require 'roo-xls'
require 'pry'

def log(f,hdr)
  fp = open("get-budget-plan.log","a")
  fp.write("#{f}\n#{hdr.join('|')}\n")
  fp.close
end

def get_header(xls,sheet)
  xls.default_sheet = xls.sheets[sheet]
  row = 0
  total = 0
  found = false
  (2..7).each do |r|
    total = 0
    (1..26).each do |c|
      s = xls.cell(r,c)
      if s.to_s.upcase =~ /TOTAL/
        total += 1
        row = r
        if total > 3
          found = true
        end
      end
    end
    break if found
  end
  fname = xls.info.split("\n")[0]
  hdr = []
  n = 0
  (1..26).each do |c|
    n += 1
    s = xls.cell(row,c)
    dat = "#{n}:#{s.to_s.gsub(/\n/,'').strip}"
    hdr.push(dat)
  end
  hdr
  log(fname,hdr)
end

def get_info(f)
  fx = f.gsub(/\ \-/,'-').gsub(/\-\ /,'-')
  #puts "fx: #{fx}"
  proj = fx.split('/').last.split(' ').first
  num_sheets = 0
  n = 0
  ref_n = 0
  max_col = 0
  sheet_name = nil
  x = Roo::Spreadsheet.open(f)
  info = x.info.split("\n")
  info.each do |i|
    if i =~ /^Number of sheets/
      num_sheets = i.split(':').last.strip.to_i
    elsif i =~ /^Sheets/
      ss = i.split(':').last.strip.split(',')
      if num_sheets == 1
        sheet_name = ss[0].strip
        max_col = x.sheet(0).row(1).length
      else
        n = 0
        ss.each do |s|
          sheet_name = s.strip
          if s.upcase =~ /PLAN/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            #puts "ref_n: #{ref_n} sheet_name: #{sheet_name} s.upcase: #{s.upcase}"
            break
          elsif s.upcase =~ /BUD/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.upcase =~ /TOTAL/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.upcase =~ /YEAR/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.upcase =~ /REVI/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          else
            ref_n = 0
            sheet_name = ss[0].strip            
            max_col = x.sheet(0).row(1).length
          end
          n += 1
        end
      end
    end
  end
  hdr = get_header(x,ref_n)
  hdr
end

entries = Dir.glob("/opt/tucdocs/XLS/Budget\ plan\ FY\ 2018/*/**")

entries.sort.each do |f|
  next if f !~ /xls/
  headers = get_info(f)
end

