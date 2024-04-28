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

  def test_operator_equal
    free_month      = Period.new('01/01/2021'..'31/01/2021')
    week            = Period.week('01/01/2021')
    standard_month  = Period.month('01/01/2021')

    assert free_month == standard_month
    assert free_month == 31.days
    assert free_month == 2678400

    assert free_month != week
    assert standard_month != week

    assert_raises ArgumentError do
      free_month == nil
    end
  end

  def test_operator_triple_equal
    free_month      = Period.new('01/01/2021'..'31/01/2021')
    standard_month  = Period.month('01/01/2021')

    assert !( free_month === standard_month )
    assert !( free_month === 31.days )
    assert !( free_month === 2678400 )

    assert !( free_month === standard_month )

    assert free_month === free_month
    assert standard_month === standard_month
  end

  def test_operator_and
    first  = Period.new('01/01/2021'...'20/01/2021')
    second = Period.new('10/01/2021'..'31/01/2021')

    assert first & second == Period.new('10/01/2021'...'20/01/2021')

    month = Period.month('01/01/2021')
    week  = Period.week('01/01/2021')

    assert month & week == Period.new('01/01/2021'..'03/01/2021')

    week  = Period.week('05/01/2021')
    assert month & week == week
    assert week & month == week
    assert month & Period.week('01/03/2021') == nil

    assert_equal (Period['01/01/2021'..'20/01/2021'] & Period['10/01/2021'...'30/01/2021']).to_s,
                  'From the 10 January 2021 to the 20 January 2021 included'

    assert_equal (Period['01/01/2021'...'20/01/2021'] & Period['10/01/2021'..'30/01/2021']).to_s,
                  'From the 10 January 2021 to the 20 January 2021 excluded'
  end

  def test_operator_or
    first  = Period.new('01/01/2021'..'20/01/2021')
    second = Period.new('10/01/2021'..'31/01/2021')

    assert first | second == Period.month('01/01/2021')

    month = Period.month('01/01/2021')
    week  = Period.week('01/01/2021')

    assert month | week == Period.new('28/12/2020'..'31/01/2021')

    assert_equal (Period['01/01/2021'..'20/01/2021'] | Period['10/01/2021'...'30/01/2021']).to_s,
                  'From the 01 January 2021 to the 30 January 2021 excluded'

    assert_equal (Period['01/01/2021'...'20/01/2021'] | Period['10/01/2021'..'30/01/2021']).to_s,
                  'From the 01 January 2021 to the 30 January 2021 included'

    assert Period.month('01/01/2021') | Period.month('01/02/2021') | Period.month('01/03/2021') == Period.quarter('01/01/2021')

    assert Period['01/01/2021'..'09/01/2021']  | Period['10/01/2021'..'20/01/2021'] == Period['01/01/2021'..'20/01/2021']
    assert Period['01/01/2021'...'09/01/2021'] | Period['10/01/2021'..'20/01/2021'] == nil
  end

end
