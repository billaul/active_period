require 'minitest/autorun'
require 'period'

class TestYear < Minitest::Test
  # Year object
  def test_new_year_form_string
    assert_instance_of Period::Year,
                       Period::Year.new('01/01/2017')
  end

  def test_new_year_form_date
    assert_instance_of Period::Year,
                       Period::Year.new(Date.today)
  end

  def test_new_year_form_time
    assert_instance_of Period::Year,
                       Period::Year.new(Time.now)
  end

  def test_year_to_s
    assert_equal '2017',
                 Period::Year.new('01/01/2017').to_s
  end

  def test_year_i18n
    assert_equal '2017',
                 Period::Year.new('01/01/2017').i18n
  end

  def test_year_next
    assert_equal '2018',
                 Period::Year.new('01/01/2017').next.to_s
  end

  def test_year_prev
    assert_equal '2016',
                 Period::Year.new('01/01/2017').prev.to_s
  end

  def test_year_to_i
    assert_equal 1.year.to_i,
                 Period::Year.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal Period::Year.new('01/01/2017').prev,
                 (Period::Year.new('01/01/2017') - 1.day)
  end

  def test_month_substract
    assert_equal Period::Year.new('01/01/2017').prev,
                 (Period::Year.new('01/01/2017') - 1.month)
  end

  def test_day_add
    assert_equal Period::Year.new('01/01/2017').next,
                 (Period::Year.new('01/01/2017') + 1.day)
  end

  def test_month_add
    assert_equal Period::Year.new('01/01/2017').next,
                 (Period::Year.new('01/01/2017') + 1.month)
  end

  # Year HasMany
  def test_year_has_many_days
    assert_equal 365,
                 Period::Year.new('01/01/2017').days.count
  end

  def test_year_has_many_weeks
    assert_equal 52, Period::Year.new('01/01/2017').weeks.count
    assert_equal 53, Period::Year.new('01/01/2020').weeks.count
  end

  def test_year_has_many_months
    assert_equal 12,
                 Period::Year.new('01/01/2017').months.count
  end

  def test_year_has_many_quarters
    assert_equal 4,
                 Period::Year.new('01/01/2017').quarters.count
  end
end
