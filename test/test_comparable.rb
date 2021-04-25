require 'minitest/autorun'
require 'active_period'

class TestComparable < Minitest::Test

  # TODO
  # Write tests for every has_many relations

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

  def test_include?
    assert period.include? '02/02/2020'.to_date
    assert beginless_period.include? '02/02/2020'.to_date
    assert endless_period.include? '02/02/2020'.to_date
    assert boundless_period.include? '02/02/2020'.to_date

    assert beginless_period.include? '02/02/2030'.to_date
    assert endless_period.include? '02/02/2000'.to_date
  end

end
