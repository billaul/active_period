require 'minitest/autorun'
require 'active_period'

class TestFreePeriod < Minitest::Test

  def period
    Period.new '01/01/2020'..'10/10/2020'
  end

  def range_to_period
    ('01/01/2020'..'10/10/2020').to_period
  end

  def test_new
    assert_raises ArgumentError do
      Period.new 42
    end
    assert_kind_of ActivePeriod::FreePeriod, Period.new(42..451)

    assert_raises ArgumentError do
      Period.new '01/01/2021'..'10/10/2020'
    end
    assert_raises ArgumentError do
      Period.new '01/01/2020'..'10/10/2000'
    end
    assert_raises ArgumentError do
      Period.new '01/01/2020'...'01/01/2020'
    end
    assert_raises ArgumentError do
      Period.new('01/01/2020'.., allow_endless: false)
    end
    assert_raises ArgumentError do
      Period.new('01/01/2020'..'', allow_endless: false)
    end
    assert_raises ArgumentError do
      Period.new(..'01/01/2020', allow_beginless: false)
    end
    assert_raises ArgumentError do
      Period.new(''..'01/01/2020', allow_beginless: false)
    end

    assert_kind_of ActivePeriod::FreePeriod, Period.new('01/01/2020'..'')
    assert_kind_of ActivePeriod::FreePeriod, Period.new(..'01/01/2020')
    assert_kind_of ActivePeriod::FreePeriod, Period.new(''..)

    assert_equal period, range_to_period
  end

  def test_from
    assert_equal period.from,      '01/01/2020'.to_time.beginning_of_day
    assert_equal period.beginning, '01/01/2020'.to_time.beginning_of_day
    assert_equal period.first,     '01/01/2020'.to_time.beginning_of_day
  end

  def test_to
    assert_equal period.to,   '10/10/2020'.to_time.end_of_day
    assert_equal period.end,  '10/10/2020'.to_time.end_of_day
    assert_equal period.last, '10/10/2020'.to_time.end_of_day
  end

  def test_next
    assert_raises NotImplementedError do
      period.next
    end
  end

  def test_prev
    assert_raises NotImplementedError do
      period.prev
    end
  end

  def test_include?
    assert period.include? '02/02/2020'.to_date
    assert period.include? '02/02/2020'.to_datetime
    assert period.include? '02/02/2020'.to_time

    assert !(period.include? '02/02/2019'.to_date)
    assert !(period.include? '02/02/2019'.to_datetime)
    assert !(period.include? '02/02/2019'.to_time)

    assert period.include? Period.day('02/02/2020')

    assert_raises ArgumentError do
      period.include? '01/01/2020'
    end
  end

  def test_operator_comparable
    assert period < 1.year
    assert period > 1.month
    assert_equal period <=> 1.year, -1
    assert_equal period <=> 1.month, 1
    assert_equal period <=> ActiveSupport::Duration.build(period.to_i), 0
  end

  def test_to_i
    assert_equal period.to_i, 24537600
  end

  def test_substract
    assert_equal period - 1.month, Period.new('01/12/2019'..'10/09/2020')
  end

  def test_add
    assert_equal period + 1.month, Period.new('01/02/2020'..'10/11/2020')
  end

  def test_equal_ending_excluded
    assert Period.new('01/01/2020'...'01/02/2020') == Period.month('01/01/2020')
  end

  def test_equal_ending_included
    assert Period.new('01/01/2020'..'31/01/2020') == Period.month('01/01/2020')
  end

  def test_to_s_included
    assert_equal period.to_s, 'From the 01 January 2020 to the 10 October 2020 included'
    I18n.locale = :fr
    assert_equal period.to_s, 'Du 01 janvier 2020 au 10 octobre 2020 inclus'
    I18n.locale = :en
  end

  def test_to_s_excluded
    period = Period.new '01/01/2020'...'10/10/2020'
    assert_equal period.to_s, 'From the 01 January 2020 to the 10 October 2020 excluded'
    I18n.locale = :fr
    assert_equal period.to_s, 'Du 01 janvier 2020 au 10 octobre 2020 exclue'
    I18n.locale = :en
  end

  def test_has_many_days
    assert Period.new('01/01/2021'...'01/02/2021').days.count == 31
  end

  def test_has_many_weeks
    assert Period.new('01/01/2021'...'01/02/2021').weeks.count == 5
  end

  def test_has_many_months
    assert Period.new('01/01/2021'...'01/02/2021').months.count == 1
    assert Period.new('01/01/2021'..'01/02/2021').months.count == 2
  end

  def test_has_many_quarters
    assert Period.new('01/01/2021'...'01/04/2021').quarters.count == 1
    assert Period.new('01/01/2021'..'01/04/2021').quarters.count == 2
  end

  def test_has_many_years
    assert Period.new('01/01/2021'...'01/01/2022').years.count == 1
    assert Period.new('01/01/2021'..'01/01/2022').years.count == 2
  end

  def test_no_method_error
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
  end

  def test_include
    # Januart 2021
    this = Period.new('01/01/2021'...'01/02/2021')
    this.weeks.each do |week|
      if week == this.weeks.first
        assert !this.include?(week)
      else
        assert this.include?(week)
      end
    end

    # February 2021
    this = Period.new('01/02/2021'...'01/03/2021')
    this.weeks.each do |week|
      assert this.include?(week)
    end

    # March 2021
    this = Period.new('01/03/2021'...'01/04/2021')
    this.weeks.each do |week|
      if week == this.weeks.last
        assert !this.include?(week)
      else
        assert this.include?(week)
      end
    end

    # April 2021
    this = Period.new('01/04/2021'...'01/05/2021')
    this.weeks.each do |week|
      if week == this.weeks.first || week == this.weeks.last
        assert !this.include?(week)
      else
        assert this.include?(week)
      end
    end
  end

end
