require 'minitest/autorun'
require 'period'

class TestQuarter < Minitest::Test
  # Quarter object
  def test_new_quarter_form_string
    assert_instance_of ActivePeriod::Quarter,
                       ActivePeriod::Quarter.new('01/01/2017')
  end

  def test_new_quarter_form_date
    assert_instance_of ActivePeriod::Quarter,
                       ActivePeriod::Quarter.new(Date.today)
  end

  def test_new_quarter_form_time
    assert_instance_of ActivePeriod::Quarter,
                       ActivePeriod::Quarter.new(Time.now)
  end

  def test_quarter_to_s
    assert_equal '1 quarter 2017',
                 ActivePeriod::Quarter.new('01/01/2017').to_s
  end

  def test_quarter_i18n
    assert_equal '1 quarter 2017',
                 ActivePeriod::Quarter.new('01/01/2017').i18n
  end

  def test_quarter_next
    assert_equal '2 quarter 2017',
                 ActivePeriod::Quarter.new('01/01/2017').next.to_s
  end

  def test_quarter_prev
    assert_equal '4 quarter 2016',
                 ActivePeriod::Quarter.new('01/01/2017').prev.to_s
  end

  def test_quarter_to_i
    assert_equal 1.quarter.to_i,
                 ActivePeriod::Quarter.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal ActivePeriod::Quarter.new('01/01/2017').prev,
                 (ActivePeriod::Quarter.new('01/01/2017') - 1.day)
  end

  def test_month_substract
    assert_equal ActivePeriod::Quarter.new('01/01/2017').prev,
                 (ActivePeriod::Quarter.new('01/01/2017') - 1.month)
  end

  def test_day_add
    assert_equal ActivePeriod::Quarter.new('01/01/2017').next,
                 (ActivePeriod::Quarter.new('01/01/2017') + 1.day)
  end

  def test_month_add
    assert_equal ActivePeriod::Quarter.new('01/01/2017').next,
                 (ActivePeriod::Quarter.new('01/01/2017') + 1.month)
  end

  # Quarter BelongsTo
  def test_quarter_belongs_to_year
    assert_equal ActivePeriod::Year.new(ActivePeriod::Quarter.new('01/01/2017').from),
                 ActivePeriod::Quarter.new('01/01/2017').year
  end

  # Quarter HasMany
  def test_quarter_has_many_days
    assert_equal 90,
                 ActivePeriod::Quarter.new('01/01/2017').days.count
  end

  def test_quarter_has_many_weeks
    assert_equal 13, ActivePeriod::Quarter.new('01/01/2017').weeks.count
    assert_equal 13, ActivePeriod::Quarter.new('01/04/2017').weeks.count
    assert_equal 13, ActivePeriod::Quarter.new('01/07/2017').weeks.count
    assert_equal 13, ActivePeriod::Quarter.new('01/10/2017').weeks.count

    assert_equal 13, ActivePeriod::Quarter.new('01/01/2020').weeks.count
    assert_equal 13, ActivePeriod::Quarter.new('01/04/2020').weeks.count
    assert_equal 13, ActivePeriod::Quarter.new('01/07/2020').weeks.count
    assert_equal 14, ActivePeriod::Quarter.new('01/10/2020').weeks.count
  end

  def test_quarter_has_many_months
    assert_equal 3,
                 ActivePeriod::Quarter.new('01/01/2017').months.count
  end

end
