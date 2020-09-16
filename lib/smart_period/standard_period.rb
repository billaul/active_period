require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

class SmartPeriod::StandardPeriod < SmartPeriod::FreePeriod
  def initialize(object)
    raise ArgumentError, I18n.t(:must_implement_to_datetime, scope: :standard_period) unless object.respond_to? :to_datetime

    date = (object.is_a?(DateTime) ? object : object.to_time.to_datetime)
    super(date.send("beginning_of_#{_period}")..date.send("end_of_#{_period}"))
  end

  def next
    self.class.new(from.send("next_#{_period}"))
  end
  alias succ next

  def prev
    self.class.new(from.send("prev_#{_period}"))
  end

  def _period
    self.class._period
  end

  def self._period
    name.split('::').last.downcase
  end

  def to_i
    1.send(_period)
  end

  def -(duration)
    self.class.new(from - duration)
  end

  def +(duration)
    self.class.new(from + duration)
  end

  def ==(other)
    raise ArgumentError unless other.class.ancestors.include?(SmartPeriod::FreePeriod)

    from == other.from && to == other.to
  end

  def to_s
    raise NotImplementedError
  end

  def i18n
    raise NotImplementedError
  end

  def i18n_scope
    [:standard_period, _period]
  end
end
