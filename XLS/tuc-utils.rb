require 'roo-xls'

class Tuc
  def initialize(fn)
    @xl = Roo::Spreadsheet.open(fn)
    sheets = @xl.sheets
    sheets.each do |s|
      if s.upcase =~ /PLAN/
        @xl.default_sheet = @xl.sheets[sheets.index(s)]
      end
    end
  end

  def cell(row,col)
    @xl.cell(row,col).to_s.tr("\n",' ').squeeze(' ')
  end

  def column(col)
    @xl.column(col)
  end

  def row(row)
    @xl.row(row)
  end

  def sheets
    @xl.sheets
  end

  # FISCAL YEAR start September 1 to August 31
  def fy(datestr)
    puts datestr
    exit
    d = Date.parse(datestr)
    m = d.month
    y = d.year
    yx = y % 100
    if m > 8
      "FY#{yx + 1}"
    else
      "FY#{yx}"
    end
  end
end
