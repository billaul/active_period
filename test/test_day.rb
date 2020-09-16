require 'minitest/autorun'
require 'smart_period'

class TestDay < Minitest::Test
  # Day object

  def test_new_day_form_string
    assert_instance_of SmartPeriod::Day,
                       SmartPeriod::Day.new('01/01/2017')
  end

  def test_new_day_form_date
    assert_instance_of SmartPeriod::Day,
                       SmartPeriod::Day.new(Date.today)
  end

  def test_new_day_form_time
    assert_instance_of SmartPeriod::Day,
                       SmartPeriod::Day.new(Time.now)
  end

  def test_day_to_s
    assert_equal '01/01/2017',
                 SmartPeriod::Day.new('01/01/2017').to_s
  end

  def test_day_i18n
    assert_equal 'Sunday 1 January 2017',
                 SmartPeriod::Day.new('01/01/2017').i18n
  end

  def test_day_next
    assert_equal '02/01/2017',
                 SmartPeriod::Day.new('01/01/2017').next.to_s
  end

  def test_day_prev
    assert_equal '31/12/2016',
                 SmartPeriod::Day.new('01/01/2017').prev.to_s
  end

  def test_day_to_i
    assert_equal 86_400,
                 SmartPeriod::Day.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal SmartPeriod::Day.new('31/12/2016'),
                 (SmartPeriod::Day.new('01/01/2017') - 1.day)
  end

  def test_day_add
    assert_equal SmartPeriod::Day.new('02/01/2017'),
                 (SmartPeriod::Day.new('01/01/2017') + 1.day)
  end

  # Day BelongsTo

  def test_day_belongs_to_week
    assert_equal SmartPeriod::Week.new('01/01/2017'),
                 SmartPeriod::Day.new('01/01/2017').week
  end

  def test_day_belongs_to_month
    assert_equal SmartPeriod::Month.new('01/01/2017'),
                 SmartPeriod::Day.new('01/01/2017').month
  end

  def test_day_belongs_to_quarter
    assert_equal SmartPeriod::Quarter.new('01/01/2017'),
                 SmartPeriod::Day.new('01/01/2017').quarter
  end

  def test_day_belongs_to_year
    assert_equal SmartPeriod::Year.new('01/01/2017'),
                 SmartPeriod::Day.new('01/01/2017').year
  end
end
