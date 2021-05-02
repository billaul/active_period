require 'minitest/autorun'
require 'active_period'

class TestDay < Minitest::Test
  # Day object
  def test_new_day_from_period_module
    assert_instance_of ActivePeriod::Day,
                       Period.today
    assert_equal ActivePeriod::Day.new(Date.today), Period.today
  end

  def test_new_day_form_string
    assert_instance_of ActivePeriod::Day,
                       ActivePeriod::Day.new('01/01/2017')
  end

  def test_new_day_form_date
    assert_instance_of ActivePeriod::Day,
                       ActivePeriod::Day.new(Date.today)
  end

  def test_new_day_form_time
    assert_instance_of ActivePeriod::Day,
                       ActivePeriod::Day.new(Time.now)
  end

  def test_day_to_s
    assert_equal '01/01/2017',
                 ActivePeriod::Day.new('01/01/2017').to_s
  end

  def test_day_i18n
    assert_equal 'Sunday 1 January 2017',
                 ActivePeriod::Day.new('01/01/2017').i18n

    assert_equal '01/01/2017',
                 ActivePeriod::Day.new('01/01/2017').i18n {|from, to| from.strftime('%d/%m/%Y')}
  end

  def test_day_next
    assert_equal '02/01/2017',
                 ActivePeriod::Day.new('01/01/2017').next.to_s
  end

  def test_day_prev
    assert_equal '31/12/2016',
                 ActivePeriod::Day.new('01/01/2017').prev.to_s
  end

  def test_day_to_i
    assert_equal 86_400,
                 ActivePeriod::Day.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal ActivePeriod::Day.new('31/12/2016'),
                 (ActivePeriod::Day.new('01/01/2017') - 1.day)
  end

  def test_day_add
    assert_equal ActivePeriod::Day.new('02/01/2017'),
                 (ActivePeriod::Day.new('01/01/2017') + 1.day)
  end

  # Day BelongsTo
  def test_day_belongs_to_week
    assert_equal ActivePeriod::Week.new('01/01/2017'),
                 ActivePeriod::Day.new('01/01/2017').week
  end

  def test_day_belongs_to_month
    assert_equal ActivePeriod::Month.new('01/01/2017'),
                 ActivePeriod::Day.new('01/01/2017').month
  end

  def test_day_belongs_to_quarter
    assert_equal ActivePeriod::Quarter.new('01/01/2017'),
                 ActivePeriod::Day.new('01/01/2017').quarter
  end

  def test_day_belongs_to_year
    assert_equal ActivePeriod::Year.new('01/01/2017'),
                 ActivePeriod::Day.new('01/01/2017').year
  end

  def test_no_method_error
    period = ActivePeriod::Day.new('01/01/2017')
    assert_raises NoMethodError do
      period.day
    end
    assert_raises NoMethodError do
      period.days
    end
    assert_raises NoMethodError do
      period.weeks
    end
    assert_raises NoMethodError do
      period.months
    end
    assert_raises NoMethodError do
      period.quarters
    end
    assert_raises NoMethodError do
      period.years
    end
  end

  def test_include
    this = Period.today
    assert  this.include?(Period.today)
    assert !this.include?(Period.yesterday)
    assert !this.include?(Period.tomorrow)

    assert !this.include?(Period.this_week)
    assert !this.include?(Period.this_month)
    assert !this.include?(Period.this_quarter)
    assert !this.include?(Period.this_year)
  end

  def test_included
    this = Period.today
    assert  Period.today.include?(this)
    assert !Period.yesterday.include?(this)
    assert !Period.tomorrow.include?(this)

    assert  Period.this_week.include?(this)
    assert  Period.this_month.include?(this)
    assert  Period.this_quarter.include?(this)
    assert  Period.this_year.include?(this)
  end

end
