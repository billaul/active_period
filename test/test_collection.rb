require 'minitest/autorun'
require 'active_period'

class TestCollection < Minitest::Test

  def test_each
    assert_raises RangeError do
      Period.new(..'10/10/2020').days.each
    end
  end

  def test_reverse_each
    assert_raises RangeError do
      Period.new('10/10/2020'..).days.reverse_each
    end
  end
  # Period.this_week.days.each {|e| puts e} => return ActivePeriod::Collection

end
