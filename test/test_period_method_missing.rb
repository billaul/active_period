require 'minitest/autorun'
require 'active_period'

# Testing
# /(last|next)_\d+_(day|week|month|quarter|year)s?(_from_now)?/
# AND
# /^last_(\d+)_(day|week|month|quarter|year)s?_to_next_(\d+)_(day|week|month|quarter|year)s?$/
class TestPeriodMethodMissing < Minitest::Test
  # /(last|next)_\d+_(day)s?(_from_now)?/
  def test_last_x_day
    assert_equal Period.last_10_day,
                 Period[10.day.ago ... Time.now.end_of_day]
  end

  def test_last_x_days
    assert_equal Period.last_10_days,
                 Period[10.day.ago ... Time.now.end_of_day]
  end

  def test_last_x_day_from_now
    assert_equal Period.last_10_day_from_now,
                 Period[10.day.ago .. Time.now.end_of_day]
  end

  def test_last_x_days_from_now
    assert_equal Period.last_10_days_from_now,
                 Period[10.day.ago .. Time.now.end_of_day]
  end

  def test_next_x_day
    assert_equal Period.next_10_day,
                 Period[1.day.from_now.beginning_of_day .. 10.day.from_now.end_of_day]
  end

  def test_next_x_days
    assert_equal Period.next_10_days,
                 Period[1.day.from_now.beginning_of_day .. 10.day.from_now.end_of_day]
  end

  def test_next_x_day_from_now
    assert_equal Period.next_10_day_from_now,
                 Period[Time.now.beginning_of_day .. 10.day.from_now.end_of_day]
  end

  def test_next_x_days_from_now
    assert_equal Period.next_10_days_from_now,
                 Period[Time.now.beginning_of_day .. 10.day.from_now.end_of_day]
  end


  # /(last|next)_\d+_(week)s?(_from_now)?/
  def test_last_x_week
    assert_equal Period.last_10_week,
                 Period[10.week.ago.beginning_of_week .. 1.week.ago.end_of_week]
  end

  def test_last_x_weeks
    assert_equal Period.last_10_weeks,
                 Period[10.week.ago.beginning_of_week .. 1.week.ago.end_of_week]
  end

  def test_last_x_week_from_now
    assert_equal Period.last_10_week_from_now,
                 Period[10.week.ago.beginning_of_week .. Time.now.end_of_week]
  end

  def test_last_x_weeks_from_now
    assert_equal Period.last_10_weeks_from_now,
                 Period[10.week.ago.beginning_of_week .. Time.now.end_of_week]
  end

  def test_next_x_week
    assert_equal Period.next_10_week,
                 Period[1.week.from_now.beginning_of_week .. 10.week.from_now.end_of_week]
  end

  def test_next_x_weeks
    assert_equal Period.next_10_weeks,
                 Period[1.week.from_now.beginning_of_week .. 10.week.from_now.end_of_week]
  end

  def test_next_x_week_from_now
    assert_equal Period.next_10_week_from_now,
                 Period[Time.now.beginning_of_week .. 10.week.from_now.end_of_week]
  end

  def test_next_x_weeks_from_now
    assert_equal Period.next_10_weeks_from_now,
                 Period[Time.now.beginning_of_week .. 10.week.from_now.end_of_week]
  end

  # /(last|next)_\d+_(month)s?(_from_now)?/
  def test_last_x_month
    assert_equal Period.last_10_month,
                 Period[10.month.ago.beginning_of_month .. 1.month.ago.end_of_month]
  end

  def test_last_x_months
    assert_equal Period.last_10_months,
                 Period[10.month.ago.beginning_of_month .. 1.month.ago.end_of_month]
  end

  def test_last_x_month_from_now
    assert_equal Period.last_10_month_from_now,
                 Period[10.month.ago.beginning_of_month .. Time.now.end_of_month]
  end

  def test_last_x_months_from_now
    assert_equal Period.last_10_months_from_now,
                 Period[10.month.ago.beginning_of_month .. Time.now.end_of_month]
  end

  def test_next_x_month
    assert_equal Period.next_10_month,
                 Period[1.month.from_now.beginning_of_month .. 10.month.from_now.end_of_month]
  end

  def test_next_x_months
    assert_equal Period.next_10_months,
                 Period[1.month.from_now.beginning_of_month .. 10.month.from_now.end_of_month]
  end

  def test_next_x_month_from_now
    assert_equal Period.next_10_month_from_now,
                 Period[Time.now.beginning_of_month .. 10.month.from_now.end_of_month]
  end

  def test_next_x_months_from_now
    assert_equal Period.next_10_months_from_now,
                 Period[Time.now.beginning_of_month .. 10.month.from_now.end_of_month]
  end


  # /(last|next)_\d+_(quarter)s?(_from_now)?/
  def test_last_x_quarter
    assert_equal Period.last_10_quarter,
                 Period[10.quarter.ago.beginning_of_quarter .. 1.quarter.ago.end_of_quarter]
  end

  def test_last_x_quarters
    assert_equal Period.last_10_quarters,
                 Period[10.quarter.ago.beginning_of_quarter .. 1.quarter.ago.end_of_quarter]
  end

  def test_last_x_quarter_from_now
    assert_equal Period.last_10_quarter_from_now,
                 Period[10.quarter.ago.beginning_of_quarter .. Time.now.end_of_quarter]
  end

  def test_last_x_quarters_from_now
    assert_equal Period.last_10_quarters_from_now,
                 Period[10.quarter.ago.beginning_of_quarter .. Time.now.end_of_quarter]
  end

  def test_next_x_quarter
    assert_equal Period.next_10_quarter,
                 Period[1.quarter.from_now.beginning_of_quarter .. 10.quarter.from_now.end_of_quarter]
  end

  def test_next_x_quarters
    assert_equal Period.next_10_quarters,
                 Period[1.quarter.from_now.beginning_of_quarter .. 10.quarter.from_now.end_of_quarter]
  end

  def test_next_x_quarter_from_now
    assert_equal Period.next_10_quarter_from_now,
                 Period[Time.now.beginning_of_quarter .. 10.quarter.from_now.end_of_quarter]
  end

  def test_next_x_quarters_from_now
    assert_equal Period.next_10_quarters_from_now,
                 Period[Time.now.beginning_of_quarter .. 10.quarter.from_now.end_of_quarter]
  end


  # /(last|next)_\d+_(year)s?(_from_now)?/
  def test_last_x_year
    assert_equal Period.last_10_year,
                 Period[10.year.ago.beginning_of_year .. 1.year.ago.end_of_year]
  end

  def test_last_x_years
    assert_equal Period.last_10_years,
                 Period[10.year.ago.beginning_of_year .. 1.year.ago.end_of_year]
  end

  def test_last_x_year_from_now
    assert_equal Period.last_10_year_from_now,
                 Period[10.year.ago.beginning_of_year .. Time.now.end_of_year]
  end

  def test_last_x_years_from_now
    assert_equal Period.last_10_years_from_now,
                 Period[10.year.ago.beginning_of_year .. Time.now.end_of_year]
  end

  def test_next_x_year
    assert_equal Period.next_10_year,
                 Period[1.year.from_now.beginning_of_year .. 10.year.from_now.end_of_year]
  end

  def test_next_x_years
    assert_equal Period.next_10_years,
                 Period[1.year.from_now.beginning_of_year .. 10.year.from_now.end_of_year]
  end

  def test_next_x_year_from_now
    assert_equal Period.next_10_year_from_now,
                 Period[Time.now.beginning_of_year .. 10.year.from_now.end_of_year]
  end

  def test_next_x_years_from_now
    assert_equal Period.next_10_years_from_now,
                 Period[Time.now.beginning_of_year .. 10.year.from_now.end_of_year]
  end

  def text_last_10_day_to_next_3_week
    assert_equal Period.last_10_day_to_next_3_week,
                 Period.last_10_day_from_now | Period.next_3_week_from_now
  end

  def text_last_2_quarter_to_next_5_month
    assert_equal Period.last_2_quarter_to_next_5_month
                 Period.last_2_quarter_from_now | Period.next_5_month_from_now
  end

end
