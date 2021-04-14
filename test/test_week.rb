require 'minitest/autorun'
require 'period'

class TestWeek < Minitest::Test
  # Week object
  def test_new_week_form_string
    assert_instance_of ActivePeriod::Week,
                       ActivePeriod::Week.new('01/01/2017')
  end

  def test_new_week_form_date
    assert_instance_of ActivePeriod::Week,
                       ActivePeriod::Week.new(Date.today)
  end

  def test_new_week_form_time
    assert_instance_of ActivePeriod::Week,
                       ActivePeriod::Week.new(Time.now)
  end

  def test_week_to_s
    assert_equal '52 - 2016',
                 ActivePeriod::Week.new('01/01/2017').to_s
  end

  def test_week_i18n
    assert_equal 'Week 52 of 2016',
                 ActivePeriod::Week.new('01/01/2017').i18n
  end

  def test_week_next
    assert_equal '01 - 2017',
                 ActivePeriod::Week.new('01/01/2017').next.to_s
  end

  def test_week_prev
    assert_equal '51 - 2016',
                 ActivePeriod::Week.new('01/01/2017').prev.to_s
  end

  def test_week_to_i
    assert_equal 1.week.to_i,
                 ActivePeriod::Week.new('01/01/2017').to_i
  end

  def test_week_substract
    assert_equal ActivePeriod::Week.new('01/01/2017').prev,
                 (ActivePeriod::Week.new('01/01/2017') - 1.week)
  end

  def test_week_add
    assert_equal ActivePeriod::Week.new('01/01/2017').next,
                 (ActivePeriod::Week.new('01/01/2017') + 1.week)
  end

  # Week BelongsTo
  def test_week_belongs_to_month
    assert_equal ActivePeriod::Month.new(ActivePeriod::Week.new('01/01/2017').from),
                 ActivePeriod::Week.new('01/01/2017').month
  end

  def test_week_belongs_to_quarter
    assert_equal ActivePeriod::Quarter.new(ActivePeriod::Week.new('01/01/2017').from),
                 ActivePeriod::Week.new('01/01/2017').quarter
  end

  def test_week_belongs_to_year
    assert_equal ActivePeriod::Year.new(ActivePeriod::Week.new('01/01/2017').from),
                 ActivePeriod::Week.new('01/01/2017').year
  end

  # Week HasMany
  def test_week_has_many_days
    assert_equal 7,
                 ActivePeriod::Week.new('01/01/2017').days.count
  end

  def test_week_has_many_days_during_time_shift_winter
     Time.zone = "Europe/Paris"
     assert_equal 7,
                  ActivePeriod::Week.new('2020-10-19').days.count
  end

  def test_week_has_many_days_during_time_shift_summer
     Time.zone = "Europe/Paris"
     assert_equal 7,
                  ActivePeriod::Week.new('2020-03-29').days.count
  end


end
