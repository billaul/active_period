require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

I18n.load_path << 'locales/fr.yml'
I18n.load_path << 'locales/en.yml'

class SmartPeriod::FreePeriod < Range
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
      from = from.is_a?(DateTime) ? from : from.to_time.to_datetime.beginning_of_day
    rescue StandardError
      raise ::ArgumentError, I18n.t(:start_date_is_invalid, scope: :free_period)
    end

    begin
      to = to.is_a?(DateTime) ? to : to.to_time.to_datetime.end_of_day
    rescue StandardError
      raise ::ArgumentError, I18n.t(:end_date_is_invalid, scope: :free_period)
    end

    raise ::ArgumentError, I18n.t(:start_is_greater_than_end, scope: :free_period) if from > to

    super(from, to, exclude_end = false)
  end

  alias from first
  alias beginning first

  alias to last
  alias end last

  def next
    raise NotImplementedError
  end
  alias succ next

  def prev
    raise NotImplementedError
  end

  def self.from_date(_date)
    raise NotImplementedError
  end

  def include?(other)
    if other.class.in?([DateTime, Time, ActiveSupport::TimeWithZone])
      from.to_i <= other.to_i && other.to_i <= to.to_i
    elsif other.is_a? Date
      super(Period::Day.new(other))
    elsif other.class.ancestors.include?(Period::FreePeriod)
      super(other)
    else
      raise ArgumentError, I18n.t(:incomparable_error, scope: :free_period)
    end
  end

  def <=>(other)
    if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
      to_i <=> other.to_i
    elsif self.class != other.class
      raise ArgumentError, I18n.t(:incomparable_error, scope: :free_period)
    else
      (from <=> other)
    end
  end

  def to_i
    days.count.days
  end

  def -(duration)
    self.class.new((from - duration)..(to - duration))
  end

  def to_s(format: '%d %B %Y')
    I18n.t(:default_format,
           scope: :free_period,
           from:  I18n.l(from, format: format),
           to:    I18n.l(to, format: format))
  end

  def i18n(&block)
    return yield(from, to) if block.present?

    to_s
  end
end
