require 'minitest/autorun'
require 'period'

class TestDay < Minitest::Test
  # Period module method
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
end
