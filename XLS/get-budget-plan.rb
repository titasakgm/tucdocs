#!/usr/bin/ruby

require 'roo-xls'
require 'pry'

def log(f,hdr)
  fp = open("get-budget-plan.log","a")
  fp.write("#{f}\n#{hdr.join('|')}\n")
  fp.close
end

def get_header(xls,sheet)
  #puts "sheet: #{sheet}"
  xls.default_sheet = xls.sheets[sheet]
  row = 0
  total = 0
  found = false
  (1..10).each do |r|
    total = 0
    (1..26).each do |c|
      s = xls.cell(r,c)
      if s.to_s.upcase =~ /SEP/ and s.to_s.length < 10
        row = r
        s2 = xls.cell(r,c+2)
        if s2.upcase =~ /NOV/        
          found = true
          #puts "*** row: #{row} s: #{s}"
        end
      elsif s.to_s =~ /\-09\-/ and xls.cell(r,c+1).to_s =~ /\-10\-/
        row = r
        found = true
        #puts "*** row: #{row} s: #{s}"
      end
    end
    break if found
  end

  fname = xls.info.split("\n")[0]
  hdr_row = row
  hdr = []
  hdrx = []
  ref_sep = 0
  n = 0
  (1..26).each do |c|
    n += 1
    s = xls.cell(row,c)
    #puts "s: [#{s}] (#{s.to_s.length})"
    if s.nil? or s.to_s.length == 0
      sx = xls.cell(row-1,c)
      if sx.nil? # merger 3 rows!!! FIX FOR GAP-CB
        sx = xls.cell(row-2,c)
        sx = '' if sx.to_s.include?(',') # FIX FOR OH-WFD
      end
      dat = "#{n}:#{sx.to_s.gsub(/\n/,' ').strip.squeeze(' ')}"
    else
      if s.to_s.upcase =~ /SEP/ or s.to_s =~ /\-09\-/
        ref_sep = c
        s = "Sep" if s.to_s =~ /\-09\-/
      end
      if s =~ /Q\d/ and s.to_s.length == 2 # FIX for SI-PS-ITC project
        s = "Total"
      end
      dat = "#{n}:#{s}"
      dat = dat.gsub(/\n/,' ').strip.squeeze(' ')
    end
    hdr.push(dat)
    break if (ref_sep > 0) and (c > ref_sep + 16)
  end
  [sheet,hdr_row,hdr]
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
          if s.to_s.upcase =~ /PLAN/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.to_s.upcase =~ /BUD/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.to_s.upcase =~ /TOTAL/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.to_s.upcase =~ /YEAR/
            max_col = x.sheet(n).row(1).length
            ref_n = n
            break
          elsif s.to_s.upcase =~ /REVI/
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
  info = get_header(x,ref_n)
  sheet = info[0]
  hdr_row = info[1]
  hdr = info[2]
  [sheet,hdr_row,hdr]
end

entries = Dir.glob("/opt/tucdocs/XLS/Budget\ plan\ FY\ 2018/*/**")

entries.sort.each do |f|
  next if f !~ /xls/
  #next if f.upcase !~ /CEI/
  info = get_info(f)
  sheet = info[0]
  hdr_row = info[1]
  hdr = info[2].join(',')
  cmd = "./update-budget-plan.rb \"#{f}\" #{sheet} #{hdr_row} \"#{hdr}\""
  puts cmd
  system(cmd)
end
