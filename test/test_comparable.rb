require 'minitest/autorun'
require 'active_period'

class TestComparable < Minitest::Test

  def period
    Period.new '01/01/2020'..'10/10/2020'
  end

  def beginless_period
    Period.new(..'10/10/2020')
  end

  def endless_period
    Period.new('01/01/2020'..)
  end

  def boundless_period
    Period.new nil..nil
  end

  def test_clamp_on
    assert Period.this_week.clamp_on(Period.today) == Period.today
    assert Period.today.clamp_on(Period.this_week) == Period.today
    assert Period.last_month.clamp_on(Period.today) == nil
    first = Period.today.first + 10.minutes
    assert Period.today.clamp_on(first) == first
    assert Period.today.clamp_on(first - 60.minutes) == Period.today.first
    last = Period.today.last - 10.minutes
    assert Period.today.clamp_on(last) == last
    assert Period.today.clamp_on(last + 60.minutes) == Period.today.last

    assert Period.today.clamp_on(first .. last) == (first .. last)
    assert Period.today.clamp_on(first .. last+60.minutes) == (first .. Period.today.last)
    assert Period.today.clamp_on(first - 60.minutes.. last) == (Period.today.first .. last)
    assert Period.today.clamp_on(first - 60.minutes.. last+60.minutes) == Period.today
    assert Period.today.clamp_on(first - 60.minutes.. last+60.minutes).class == Range
    assert Period.today.clamp_on(1.day.from_now .. 2.day.from_now) == nil
    assert Period.today.clamp_on(2.day.ago .. 1.day.ago) == nil
  end

  def test_include?
    assert period.include?            '02/02/2020'.to_date
    assert beginless_period.include?  '02/02/2020'.to_date
    assert endless_period.include?    '02/02/2020'.to_date
    assert boundless_period.include?  '02/02/2020'.to_date

    assert !(beginless_period.include? '02/02/2030'.to_date)
    assert !(endless_period.include?   '02/02/2000'.to_date)
  end

  def test_compare
    assert period >  10.days
    assert period == 284.days
    assert period  < 300.days

    assert Period.today < 3.days.from_now
    assert Period.today > 3.days.ago

    assert (Period.today <=> 3.days.from_now) == -1
    assert (Period.today <=> 3.days.ago) == 1
  end

end
