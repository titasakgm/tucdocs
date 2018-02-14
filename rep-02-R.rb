#!/usr/bin/ruby

# REPORT-02-R LIST Research Projects
n = []
r = []

html = "<H1>Research Projects</H1>\n"

src = open("RNR").readlines
src.sort.each do |line|
  d = line.chomp.split('|')
  rnr = d[0]
  pid = d[1]
  sid = d[2]
  code = d[3]
  if rnr == 'R'
    r.push(code)
  else
    n.push(code)
  end
end

html += "<ol>\n"

r.sort.each do |p|
  html += "  <li><a href='#{p}.html'>#{p}</a></li>\n"
end

html += "</ol>\n"

dst = open("REP-02-R.html","w")
dst.write("<HTML>\n")
dst.write("<BODY>\n")
dst.write(html)
dst.write("</BODY>\n")
dst.write("</HTML>\n")
dst.close

