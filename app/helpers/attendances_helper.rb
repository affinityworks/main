module AttendancesHelper
  PDF_ROWS_PER_PAGE = 24
  PDF_MIN_BLANK_ROWS = 20

  def pdf_extra_rows(attendances_count)
    if attendances_count < PDF_ROWS_PER_PAGE
      rows_left = PDF_ROWS_PER_PAGE - attendances_count
    else
      rows_left = PDF_ROWS_PER_PAGE - (attendances_count % PDF_ROWS_PER_PAGE)
    end
    rows_left < PDF_MIN_BLANK_ROWS ? rows_left + PDF_ROWS_PER_PAGE : rows_left
  end
end
