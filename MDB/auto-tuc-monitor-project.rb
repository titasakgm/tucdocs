#!/usr/bin/ruby

nr_projs = open("tuc-nr-projects").readlines
nr_projs.each do |p|
  cmd = "./tuc-monitor-project.rb #{p.tr('&','\&')}"
  puts "cmd: #{cmd}"
  system(cmd)
end

