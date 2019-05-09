require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "has_many/months.rb"
require_relative "has_many/quarters.rb"
require_relative "has_many/years.rb"

class SmartPeriod::StandardPeriod < SmartPeriod::PeriodRange

  def initialize(object)
    raise ArgumentError unless object.respond_to? :to_datetime
    date = (object.is_a?( DateTime ) ? object : object.to_time.to_datetime)
    super(date.send("beginning_of_#{self._period}")..date.send("end_of_#{self._period}"))
  end

  def next
    self.class.new(from.send("next_#{self._period}"))
  end
  alias :succ :next

  def prev
    self.class.new(from.send("prev_#{self._period}"))
  end

  def _period
    self.class._period
  end

  def self._period
    self.name.split('::').last.downcase
  end

  def to_i
    1.send(self._period)
  end

  def -(duration)
    self.class.new(from - duration)
  end
end
