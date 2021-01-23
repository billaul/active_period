require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

class Period::FreePeriod < Range
  include Comparable

  include Period::HasMany::Days
  include Period::HasMany::Weeks
  include Period::HasMany::Months
  include Period::HasMany::Quarters
  include Period::HasMany::Years

  def initialize(range)
    raise ::ArgumentError, I18n.t(:param_must_be_a_range, scope: %i[period free_period]) unless range.class.ancestors.include?(Range)
    from = range.first
    to = range.last

    from = time_parse(range.first, I18n.t(:start_date_is_invalid, scope: %i[period free_period])).beginning_of_day
    to = time_parse(range.last, I18n.t(:end_date_is_invalid, scope: %i[period free_period])).end_of_day
    to = to.prev_day if range.exclude_end?
    raise ::ArgumentError, I18n.t(:start_is_greater_than_end, scope: %i[period free_period]) if from > to

    super(from, to)
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

  def +(duration)
    self.class.new((from + duration)..(to + duration))
  end

  def ==(other)
    raise ArgumentError unless other.class.ancestors.include?(Period::FreePeriod)

    from == other.from && to == other.to
  end

  def strftime(format)
    to_s(format: format)
  end

  def to_s(format: '%d %B %Y')
    I18n.t(:default_format,
           scope: %i[period free_period],
           from:  I18n.l(from, format: format),
           to:    I18n.l(to, format: format))
  end

  def i18n(&block)
    return yield(from, to) if block.present?

    to_s
  end

  private

  def time_parse(time, msg)
    if time.class.in? [String, Date]
      Period.env_time.parse(time.to_s)
    elsif time.class.in? [Time, ActiveSupport::TimeWithZone]
      time
    else
      raise ::ArgumentError, msg
    end
  rescue StandardError
    raise ::ArgumentError, msg
  end
end
