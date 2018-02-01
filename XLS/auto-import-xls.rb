#!/usr/bin/ruby

entries = Dir.glob("Budget plan FY 2018/**/*")

entries.each do |f|
  if f =~ /.xls/
    fn = f.gsub(' ','\ ').gsub('&','\\\&')
    project_id = f.split('/').last.upcase.split('BUDGET PLAN').first.tr(' ','')
    puts "project_id: #{project_id}"
    cmd = "./import-xls.rb /opt/tucdocs/XLS/#{fn}"
    puts cmd
    system(cmd)
  end
end

