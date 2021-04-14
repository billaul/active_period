require 'minitest/autorun'
require 'active_period'

class TestPeriod < Minitest::Test
  # Period module method
  # Test day alias
  def test_yesterday
    assert_equal Period.last_day,
                 Period.yesterday
  end

  def test_tomorrow
    assert_equal Period.next_day,
                 Period.tomorrow
  end

  def test_today
    assert_equal Period.this_day,
                 Period.today
  end

  # Test new standard period
  def test_new_day
    assert_equal ActivePeriod::Day.new(Time.now),
                 Period.day(Time.now)
  end

  def test_new_week
    assert_equal ActivePeriod::Week.new(Time.now),
                 Period.week(Time.now)
  end

  def test_new_month
    assert_equal ActivePeriod::Month.new(Time.now),
                 Period.month(Time.now)
  end

  def test_new_quarter
    assert_equal ActivePeriod::Quarter.new(Time.now),
                 Period.quarter(Time.now)
  end

  def test_new_year
    assert_equal ActivePeriod::Year.new(Time.now),
                 Period.year(Time.now)
  end

  # Test last_x_y(_from_now)
  def test_last_10_day
    assert_equal Period.last_10_days,
                 Period.new(10.days.ago..1.day.ago)
  end

  def test_last_10_day_from_now
    assert_equal Period.last_10_days_from_now,
                 Period.new(10.days.ago..0.day.ago)
  end

  def test_last_10_week
    assert_equal Period.last_10_weeks,
                 Period.new(10.week.ago.beginning_of_week..1.week.ago.end_of_week)
  end

  def test_last_10_week_from_now
    assert_equal Period.last_10_weeks_from_now,
                 Period.new(10.week.ago.beginning_of_week..0.week.ago.end_of_week)
  end

  def test_last_10_month
    assert_equal Period.last_10_months,
                 Period.new(10.month.ago.beginning_of_month..1.month.ago.end_of_month)
  end

  def test_last_10_month_from_now
    assert_equal Period.last_10_months_from_now,
                 Period.new(10.month.ago.beginning_of_month..0.month.ago.end_of_month)
  end

  def test_last_10_quarter
    assert_equal Period.last_10_quarters,
                 Period.new(10.quarter.ago.beginning_of_quarter..1.quarter.ago.end_of_quarter)
  end

  def test_last_10_quarter_from_now
    assert_equal Period.last_10_quarters_from_now,
                 Period.new(10.quarter.ago.beginning_of_quarter..0.quarter.ago.end_of_quarter)
  end

  def test_last_10_year
    assert_equal Period.last_10_years,
                 Period.new(10.year.ago.beginning_of_year..1.year.ago.end_of_year)
  end

  def test_last_10_year_from_now
    assert_equal Period.last_10_years_from_now,
                 Period.new(10.year.ago.beginning_of_year..0.year.ago.end_of_year)
  end

  # Test next_x_y(_from_now)
  def test_next_10_day
    assert_equal Period.next_10_days,
                 Period.new(1.day.from_now..10.days.from_now)
  end

  def test_next_10_day_from_now
    assert_equal Period.next_10_days_from_now,
                 Period.new(0.day.from_now..10.days.from_now)
  end

  def test_next_10_week
    assert_equal Period.next_10_weeks,
                 Period.new(1.week.from_now.beginning_of_week..10.weeks.from_now.end_of_week)
  end

  def test_next_10_week_from_now
    assert_equal Period.next_10_weeks_from_now,
                 Period.new(0.week.from_now.beginning_of_week..10.weeks.from_now.end_of_week)
  end

  def test_next_10_month
    assert_equal Period.next_10_months,
                 Period.new(1.month.from_now.beginning_of_month..10.months.from_now.end_of_month)
  end

  def test_next_10_month_from_now
    assert_equal Period.next_10_months_from_now,
                 Period.new(0.month.from_now.beginning_of_month..10.months.from_now.end_of_month)
  end

  def test_next_10_quarter
    assert_equal Period.next_10_quarters,
                 Period.new(1.quarter.from_now.beginning_of_quarter..10.quarters.from_now.end_of_quarter)
  end

  def test_next_10_quarter_from_now
    assert_equal Period.next_10_quarters_from_now,
                 Period.new(0.quarter.from_now.beginning_of_quarter..10.quarters.from_now.end_of_quarter)
  end

  def test_next_10_year
    assert_equal Period.next_10_years,
                 Period.new(1.year.from_now.beginning_of_year..10.years.from_now.end_of_year)
  end

  def test_next_10_year_from_now
    assert_equal Period.next_10_years_from_now,
                 Period.new(0.year.from_now.beginning_of_year..10.years.from_now.end_of_year)
  end

end
