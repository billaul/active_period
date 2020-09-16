require 'minitest/autorun'
require 'smart_period'

class TestWeek < Minitest::Test
  # Week object

  def test_new_week_form_string
    assert_instance_of SmartPeriod::Week,
                       SmartPeriod::Week.new('01/01/2017')
  end

  def test_new_week_form_date
    assert_instance_of SmartPeriod::Week,
                       SmartPeriod::Week.new(Date.today)
  end

  def test_new_week_form_time
    assert_instance_of SmartPeriod::Week,
                       SmartPeriod::Week.new(Time.now)
  end

  def test_week_to_s
    assert_equal '52 - 2016',
                 SmartPeriod::Week.new('01/01/2017').to_s
  end

  def test_week_i18n
    assert_equal 'Week 52 of the year 2016',
                 SmartPeriod::Week.new('01/01/2017').i18n
  end

  def test_week_next
    assert_equal '01 - 2017',
                 SmartPeriod::Week.new('01/01/2017').next.to_s
  end

  def test_week_prev
    assert_equal '51 - 2016',
                 SmartPeriod::Week.new('01/01/2017').prev.to_s
  end

  def test_week_to_i
    assert_equal 604_800,
                 SmartPeriod::Week.new('01/01/2017').to_i
  end

  def test_week_substract
    assert_equal SmartPeriod::Week.new('01/01/2017').prev,
                 (SmartPeriod::Week.new('01/01/2017') - 1.week)
  end

  def test_week_add
    assert_equal SmartPeriod::Week.new('01/01/2017').next,
                 (SmartPeriod::Week.new('01/01/2017') + 1.week)
  end

  # Week BelongsTo

  def test_week_belongs_to_month
    assert_equal SmartPeriod::Month.new(SmartPeriod::Week.new('01/01/2017').from),
                 SmartPeriod::Week.new('01/01/2017').month
  end

  def test_week_belongs_to_quarter
    assert_equal SmartPeriod::Quarter.new(SmartPeriod::Week.new('01/01/2017').from),
                 SmartPeriod::Week.new('01/01/2017').quarter
  end

  def test_week_belongs_to_year
    assert_equal SmartPeriod::Year.new(SmartPeriod::Week.new('01/01/2017').from),
                 SmartPeriod::Week.new('01/01/2017').year
  end

  # Week HasMany
  def test_week_has_many_days
    assert_equal 7,
                 SmartPeriod::Week.new('01/01/2017').days.count
  end
end
