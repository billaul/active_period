require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "has_many/months.rb"
require_relative "has_many/quarters.rb"
require_relative "has_many/years.rb"

class SmartPeriod::PeriodRange < Range
  include Comparable

  include SmartPeriod::HasMany::Days
  include SmartPeriod::HasMany::Weeks
  include SmartPeriod::HasMany::Months
  include SmartPeriod::HasMany::Quarters
  include SmartPeriod::HasMany::Years

  def initialize(range)
    from = range.first
    to = range.last

    begin
      from = from.is_a?( DateTime ) ? from : from.to_time.to_datetime.beginning_of_day
    rescue
      raise ::ArgumentError, 'Date de début invalide'
    end

    begin
      to   = to.is_a?( DateTime ) ? to : to.to_time.to_datetime.end_of_day
    rescue
      raise ::ArgumentError, 'Date de fin invalide'
    end

    raise ::ArgumentError, 'Date de début supérieur à la date de fin' if from > to

    super(from, to, exclude_end=false)
  end

  alias :from :first
  alias :beginning :first

  alias :to :last
  alias :end :last

  def next
    raise NotImplementedError
  end
  alias :succ :next

  def prev
    raise NotImplementedError
  end

  def self.from_date(date)
    raise NotImplementedError
  end

  def include?(other)
    if other.class.in?([DateTime, Time, ActiveSupport::TimeWithZone])
      self.from.to_i <= other.to_i &&  other.to_i <= self.to.to_i
    elsif other.is_a? Date
      super(Period::Day.new(other))
    elsif other.class.ancestors.include?(Period::PeriodRange)
      super(other)
    else
      raise ArgumentError, 'Cannot compare Arguments'
    end
  end

  def <=>(other)
    if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
      self.to_i <=> other.to_i
    elsif self.class != other.class
      raise ArgumentError, 'Cannot compare Arguments'
    else
      (from <=> other)
    end
  end

  def to_i
    self.days.count.days
  end

  def -(duration)
    self.class.new((from - duration)..(to - duration))
  end

  def to_s(format: '%d %B %Y')
    "Du #{I18n.l(from, format: '%d %B %Y')} au #{I18n.l(to, format: '%d %B %Y')} inclus"
  end
end
