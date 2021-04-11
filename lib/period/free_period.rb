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

  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @param range [Range] A valid range
  # @return [self] A new instance of Period::FreePeriod
  # @raise ArgumentError if the params range is not a Range
  # @raise ArgumentError if the params range is invalid
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

  # @raise NotImplementedError This method must be implemented id daughter class
  def next
    raise NotImplementedError
  end
  alias succ next

  # @raise NotImplementedError This method must be implemented id daughter class
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

  # Don't return an Integer. ActiveSupport::Duration is a better numeric
  # representation a in time manipulation context
  # @return [ActiveSupport::Duration] Number of day
  def to_i
    days.count.days
  end

  # Shift a period to the past
  # @params see https://api.rubyonrails.org/classes/ActiveSupport/TimeWithZone.html#method-i-2B
  # @return [self] A new period of the same kind
  def -(duration)
    self.class.new((from - duration)..(to - duration))
  end

  # Shift a period to the future
  # @params see https://api.rubyonrails.org/classes/ActiveSupport/TimeWithZone.html#method-i-2B
  # @return [self] A new period of the same kind
  def +(duration)
    self.class.new((from + duration)..(to + duration))
  end

  # @param other [Period::FreePeriod] Any kind of Period::FreePeriod object
  # @return [Boolean] true if period are equals, false otherwise
  # @raise ArgumentError if params other is not a Period::FreePeriod of some kind
  def ==(other)
    raise ArgumentError unless other.class.ancestors.include?(Period::FreePeriod)

    from == other.from && to == other.to
  end

  # @param format [String] A valid format for I18n.l
  # @return [String] Formated string
  def strftime(format)
    to_s(format: format)
  end

  # @param format [String] A valid format for I18n.l
  # @return [String] Formated string
  def to_s(format: '%d %B %Y')
    I18n.t(:default_format,
           scope: %i[period free_period],
           from:  I18n.l(from, format: format),
           to:    I18n.l(to, format: format))
  end

  # If no block given, it's an alias to to_s
  # For a block {|from,to| ... }
  # @yieldparam from [DateTime] the start of the period
  # @yieldparam to [DateTime] the end of the period
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
