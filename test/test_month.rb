require 'minitest/autorun'
require 'smart_period'

class TestMonth < Minitest::Test
  # Month object

  def test_new_month_form_string
    assert_instance_of SmartPeriod::Month,
                       SmartPeriod::Month.new('01/01/2017')
  end

  def test_new_month_form_date
    assert_instance_of SmartPeriod::Month,
                       SmartPeriod::Month.new(Date.today)
  end

  def test_new_month_form_time
    assert_instance_of SmartPeriod::Month,
                       SmartPeriod::Month.new(Time.now)
  end

  def test_month_to_s
    assert_equal '01/2017',
                 SmartPeriod::Month.new('01/01/2017').to_s
  end

  def test_month_i18n
    assert_equal 'January 2017',
                 SmartPeriod::Month.new('01/01/2017').i18n
  end

  def test_month_next
    assert_equal '01/2017',
                 SmartPeriod::Month.new('01/01/2017').next.to_s
  end

  def test_month_prev
    assert_equal '12/2016',
                 SmartPeriod::Month.new('01/01/2017').prev.to_s
  end

  def test_month_to_i
    assert_equal 604_800,
                 SmartPeriod::Month.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal SmartPeriod::Month.new('01/01/2017').prev,
                 (SmartPeriod::Month.new('01/01/2017') - 1.day)
  end

  def test_month_substract
    assert_equal SmartPeriod::Month.new('01/01/2017').prev,
                 (SmartPeriod::Month.new('01/01/2017') - 1.month)
  end

  def test_day_add
    assert_equal SmartPeriod::Month.new('01/01/2017').next,
                 (SmartPeriod::Month.new('01/01/2017') + 1.day)
  end

  def test_month_add
    assert_equal SmartPeriod::Month.new('01/01/2017').next,
                 (SmartPeriod::Month.new('01/01/2017') + 1.month)
  end

  # Month BelongsTo

  def test_month_belongs_to_month
    assert_equal SmartPeriod::Month.new(SmartPeriod::Month.new('01/01/2017').from),
                 SmartPeriod::Month.new('01/01/2017').month
  end

  def test_month_belongs_to_quarter
    assert_equal SmartPeriod::Quarter.new(SmartPeriod::Month.new('01/01/2017').from),
                 SmartPeriod::Month.new('01/01/2017').quarter
  end

  def test_month_belongs_to_year
    assert_equal SmartPeriod::Year.new(SmartPeriod::Month.new('01/01/2017').from),
                 SmartPeriod::Month.new('01/01/2017').year
  end

  # Month HasMany
  def test_month_has_many_days
    assert_equal 7,
                 SmartPeriod::Month.new('01/01/2017').days.count
  end
end
