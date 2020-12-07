require 'minitest/autorun'
require 'period'

class TestDay < Minitest::Test
  # Day object

  def test_new_day_form_string
    assert_instance_of Period::Day,
                       Period::Day.new('01/01/2017')
  end

  def test_new_day_form_date
    assert_instance_of Period::Day,
                       Period::Day.new(Date.today)
  end

  def test_new_day_form_time
    assert_instance_of Period::Day,
                       Period::Day.new(Time.now)
  end

  def test_day_to_s
    assert_equal '01/01/2017',
                 Period::Day.new('01/01/2017').to_s
  end

  def test_day_i18n
    assert_equal 'Sunday 1 January 2017',
                 Period::Day.new('01/01/2017').i18n
  end

  def test_day_next
    assert_equal '02/01/2017',
                 Period::Day.new('01/01/2017').next.to_s
  end

  def test_day_prev
    assert_equal '31/12/2016',
                 Period::Day.new('01/01/2017').prev.to_s
  end

  def test_day_to_i
    assert_equal 86_400,
                 Period::Day.new('01/01/2017').to_i
  end

  def test_day_substract
    assert_equal Period::Day.new('31/12/2016'),
                 (Period::Day.new('01/01/2017') - 1.day)
  end

  def test_day_add
    assert_equal Period::Day.new('02/01/2017'),
                 (Period::Day.new('01/01/2017') + 1.day)
  end

  # Day BelongsTo

  def test_day_belongs_to_week
    assert_equal Period::Week.new('01/01/2017'),
                 Period::Day.new('01/01/2017').week
  end

  def test_day_belongs_to_month
    assert_equal Period::Month.new('01/01/2017'),
                 Period::Day.new('01/01/2017').month
  end

  def test_day_belongs_to_quarter
    assert_equal Period::Quarter.new('01/01/2017'),
                 Period::Day.new('01/01/2017').quarter
  end

  def test_day_belongs_to_year
    assert_equal Period::Year.new('01/01/2017'),
                 Period::Day.new('01/01/2017').year
  end
end
