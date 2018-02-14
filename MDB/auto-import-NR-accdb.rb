#!/usr/bin/ruby

require 'pry-byebug'

def find_accdb(mdb)
  if mdb =~ /AGG/
    mdb = mdb.gsub(/AGG-/,'')
  end
  accdb = 'NA'
  src = open("NR-accdbs").readlines
  src.each do |line|
    #binding.pry
    if line.upcase =~ /AGG/
      if "KPIS-PREP2START-SL-YMSM-CASCADE" =~ /#{mdb}/
        accdb = line.chomp
      end
    else
      # check space before <mdb>.ACCDB to fix ITC and SI-PS-ITC
      next if line.upcase !~ /\ #{mdb.upcase}.ACCDB/
      accdb = line.chomp
    end
  end
  accdb
  if accdb == 'NA'
    puts "ERROR: find_accdn: #{mdb} !!!!!"
    exit
  end
  accdb
end

n = 0
src = open("NR-tables").readlines
src.each do |line|
  tbl = line.chomp

  #### next if tbl !~ /agg/

  mdb = tbl.upcase.tr('_','-')

  #######################
  # FIX for NCD-CVD_Win10
  #######################
  if mdb =~ /WIN10/
    mdb = mdb.gsub('-WIN10','_WIN10')
  end 

  puts "find_accdb: #{mdb}"

  accdb = find_accdb(mdb)
  puts "tbl: #{tbl} mdb: #{mdb} => accdb: #{accdb}"
  n += 1
  cmd = "./import-NR-accdb.rb \"#{accdb}\" "
  puts "#{n}: #{cmd}"
  system(cmd)
end
