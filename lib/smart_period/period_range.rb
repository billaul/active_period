require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "has_many/months.rb"
require_relative "has_many/quarters.rb"
require_relative "has_many/years.rb"

I18n.load_path << 'locales/fr.yml'
I18n.load_path << 'locales/en.yml'

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
      raise ::ArgumentError, I18n.t(:start_date_is_invalid, scope: :period_range)
    end

    begin
      to   = to.is_a?( DateTime ) ? to : to.to_time.to_datetime.end_of_day
    rescue
      raise ::ArgumentError, I18n.t(:end_date_is_invalid, scope: :period_range)
    end

    raise ::ArgumentError, I18n.t(:start_is_greater_than_end, scope: :period_range) if from > to

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
      raise ArgumentError, I18n.t(:incomparable_error, scope: :period_range)
    end
  end

  def <=>(other)
    if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
      self.to_i <=> other.to_i
    elsif self.class != other.class
      raise ArgumentError, I18n.t(:incomparable_error, scope: :period_range)
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
    I18n.t(:default_format,
           scope: :period_range,
           from:  I18n.l(from, format: format),
           to:    I18n.l(to, format: format)
         )
  end

  def i18n(&block)
    if block.present?
      yield(from, to)
    else
      to_s
    end
  end


end
