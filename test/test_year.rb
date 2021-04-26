require 'minitest/autorun'
require 'active_period'

class TestYear < Minitest::Test
  # Year object
  def test_new_year_form_string
    assert_instance_of ActivePeriod::Year,
                       ActivePeriod::Year.new('01/01/2017')
  end

  def test_new_year_form_date
    assert_instance_of ActivePeriod::Year,
                       ActivePeriod::Year.new(Date.today)
  end

  def test_new_year_form_time
    assert_instance_of ActivePeriod::Year,
                       ActivePeriod::Year.new(Time.now)
  end

  def test_year_to_s
    assert_equal '2017',
                 ActivePeriod::Year.new('01/01/2017').to_s
  end

  def test_year_i18n
    assert_equal '2017',
                 ActivePeriod::Year.new('01/01/2017').i18n
  end

  def test_year_next
    assert_equal '2018',
                 ActivePeriod::Year.new('01/01/2017').next.to_s
  end

  def test_year_prev
    assert_equal '2016',
                 ActivePeriod::Year.new('01/01/2017').prev.to_s
  end

  def test_year_to_i
    assert_equal 1.year.to_i,
                 ActivePeriod::Year.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal ActivePeriod::Year.new('01/01/2017').prev,
                 (ActivePeriod::Year.new('01/01/2017') - 1.day)
  end

  def test_month_substract
    assert_equal ActivePeriod::Year.new('01/01/2017').prev,
                 (ActivePeriod::Year.new('01/01/2017') - 1.month)
  end

  def test_day_add
    assert_equal ActivePeriod::Year.new('01/01/2017').next,
                 (ActivePeriod::Year.new('01/01/2017') + 1.day)
  end

  def test_month_add
    assert_equal ActivePeriod::Year.new('01/01/2017').next,
                 (ActivePeriod::Year.new('01/01/2017') + 1.month)
  end

  # Year HasMany
  def test_year_has_many_days
    assert_equal 365,
                 ActivePeriod::Year.new('01/01/2017').days.count
  end

  def test_year_has_many_weeks
    assert_equal 52, ActivePeriod::Year.new('01/01/2017').weeks.count
    assert_equal 53, ActivePeriod::Year.new('01/01/2020').weeks.count
  end

  def test_year_has_many_months
    assert_equal 12,
                 ActivePeriod::Year.new('01/01/2017').months.count
  end

  def test_year_has_many_quarters
    assert_equal 4,
                 ActivePeriod::Year.new('01/01/2017').quarters.count
  end

  def test_no_method_error
    period = ActivePeriod::Year.new('01/01/2017')
    assert_raises NoMethodError do
      period.day
    end
    assert_raises NoMethodError do
      period.week
    end
    assert_raises NoMethodError do
      period.month
    end
    assert_raises NoMethodError do
      period.quarter
    end
    assert_raises NoMethodError do
      period.year
    end
    assert_raises NoMethodError do
      period.years
    end
  end
end
