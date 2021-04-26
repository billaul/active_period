require 'minitest/autorun'
require 'active_period'

class TestMonth < Minitest::Test
  # Month object
  def test_new_month_form_string
    assert_instance_of ActivePeriod::Month,
                       ActivePeriod::Month.new('01/01/2017')
  end

  def test_new_month_form_date
    assert_instance_of ActivePeriod::Month,
                       ActivePeriod::Month.new(Date.today)
  end

  def test_new_month_form_time
    assert_instance_of ActivePeriod::Month,
                       ActivePeriod::Month.new(Time.now)
  end

  def test_month_to_s
    assert_equal '01/2017',
                 ActivePeriod::Month.new('01/01/2017').to_s
  end

  def test_month_i18n
    assert_equal 'January 2017',
                 ActivePeriod::Month.new('01/01/2017').i18n
  end

  def test_month_next
    assert_equal '02/2017',
                 ActivePeriod::Month.new('01/01/2017').next.to_s
  end

  def test_month_prev
    assert_equal '12/2016',
                 ActivePeriod::Month.new('01/01/2017').prev.to_s
  end

  def test_month_to_i
    assert_equal 1.month.to_i,
                 ActivePeriod::Month.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal ActivePeriod::Month.new('01/01/2017').prev,
                 (ActivePeriod::Month.new('01/01/2017') - 1.day)
  end

  def test_month_substract
    assert_equal ActivePeriod::Month.new('01/01/2017').prev,
                 (ActivePeriod::Month.new('01/01/2017') - 1.month)
  end

  def test_day_add
    assert_equal ActivePeriod::Month.new('01/01/2017').next,
                 (ActivePeriod::Month.new('01/01/2017') + 1.day)
  end

  def test_month_add
    assert_equal ActivePeriod::Month.new('01/01/2017').next,
                 (ActivePeriod::Month.new('01/01/2017') + 1.month)
  end

  # Month BelongsTo
  def test_month_belongs_to_quarter
    assert_equal ActivePeriod::Quarter.new(ActivePeriod::Month.new('01/01/2017').from),
                 ActivePeriod::Month.new('01/01/2017').quarter
  end

  def test_month_belongs_to_year
    assert_equal ActivePeriod::Year.new(ActivePeriod::Month.new('01/01/2017').from),
                 ActivePeriod::Month.new('01/01/2017').year
  end

  # Month HasMany
  def test_month_has_many_days
    assert_equal 31,
                 ActivePeriod::Month.new('01/01/2017').days.count
  end

  def test_month_has_many_weeks
    assert_equal 4, ActivePeriod::Month.new('01/01/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/02/2017').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/03/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/04/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/05/2017').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/06/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/07/2017').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/08/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/09/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/10/2017').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/11/2017').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/12/2017').weeks.count

    assert_equal 5, ActivePeriod::Month.new('01/01/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/02/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/03/2020').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/04/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/05/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/06/2020').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/07/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/08/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/09/2020').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/10/2020').weeks.count
    assert_equal 4, ActivePeriod::Month.new('01/11/2020').weeks.count
    assert_equal 5, ActivePeriod::Month.new('01/12/2020').weeks.count
  end

  def test_no_method_error
    period = ActivePeriod::Month.new('01/01/2017')
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
      period.months
    end
    assert_raises NoMethodError do
      period.quarters
    end
    assert_raises NoMethodError do
      period.years
    end
  end
end
