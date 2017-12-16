require 'roo-xls'

class Tuc
  def initialize(fn)
    @xl = Roo::Spreadsheet.open(fn)
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

  # FISCAL YEAR start September 1 to August 31
  def fy(datestr)
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
