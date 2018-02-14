#!/usr/bin/ruby

# REPORT-01 LIST Research/Non-Research Projects
n = []
r = []

html = "<H1>TUC-MoPH</H1>\n"

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

html += "<div class='main'>\n"
html += "  <h3><a href='REP-02-R.html'><h3>Research</a> : #{r.length} Projects</h3>\n"
html += "  <h3><a href='REP-02-N.html'>Non-Research</a> : #{n.length} Projects</h3>\n"
html += "</div>\n"

dst = open("REP-01.html","w")
dst.write("<HTML>\n")
dst.write("<BODY>\n")
dst.write(html)
dst.write("</BODY>\n")
dst.write("</HTML>\n")
dst.close
