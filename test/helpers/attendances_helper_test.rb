require 'test_helper'

class AttendancesHelperTest < ActionView::TestCase
  test 'when attendances count is less than page row count' do
    attendances_count = 1
    assert_equal PDF_ROWS_PER_PAGE - attendances_count, pdf_extra_rows(attendances_count)

    attendances_count = 10
    assert_equal 2*PDF_ROWS_PER_PAGE - attendances_count, pdf_extra_rows(attendances_count)
  end

  test 'when attendances count is greater than page row count' do
    attendances_count = PDF_ROWS_PER_PAGE + 2
    rest = attendances_count % PDF_ROWS_PER_PAGE
    assert_equal PDF_ROWS_PER_PAGE - rest, pdf_extra_rows(attendances_count)

    attendances_count = PDF_ROWS_PER_PAGE + 10
    rest = attendances_count % PDF_ROWS_PER_PAGE
    assert_equal 2*PDF_ROWS_PER_PAGE - rest, pdf_extra_rows(attendances_count)
  end
end
