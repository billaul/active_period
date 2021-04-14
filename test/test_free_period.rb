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
    assert_raises ArgumentError do
      Period.new 42..451
    end
    assert_raises ArgumentError do
      Period.new '01/01/2021'..'10/10/2020'
    end
    assert_raises ArgumentError do
      Period.new '01/01/2020'..'10/10/2000'
    end
    assert_raises ArgumentError do
      Period.new '01/01/2020'...'01/01/2020'
    end
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

  def test_to_s
    assert_equal period.to_s, 'From the 01 January 2020 to the 10 October 2020 included'
    I18n.locale = :fr
    assert_equal period.to_s, 'Du 01 janvier 2020 au 10 octobre 2020 inclus'
    I18n.locale = :en
  end

end
