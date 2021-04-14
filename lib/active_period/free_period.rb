require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

class ActivePeriod::FreePeriod < Range
  include Comparable

  include ActivePeriod::HasMany::Days
  include ActivePeriod::HasMany::Weeks
  include ActivePeriod::HasMany::Months
  include ActivePeriod::HasMany::Quarters
  include ActivePeriod::HasMany::Years

  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @param range [Range] A valid range
  # @return [self] A new instance of ActivePeriod::FreePeriod
  # @raise ArgumentError if the params range is not a Range
  # @raise ArgumentError if the params range is invalid
  def initialize(range, allow_beginless: true, allow_endless: true)
    raise ::ArgumentError, I18n.t(:param_must_be_a_range, scope: %i[period free_period]) unless range.class.ancestors.include?(Range)

    from =
      if allow_beginless && nilthy?(range.begin)
        nil
      else
        time_parse(
          range.begin,
          I18n.t(:start_date_is_invalid, scope: %i[period free_period])
        ).beginning_of_day
      end

    to =
      if allow_endless && nilthy?(range.end)
        nil
      else
        time_parse(
          range.end,
          I18n.t(:end_date_is_invalid, scope: %i[period free_period])
        ).end_of_day
      end
    # raise ::ArgumentError, I18n.t(:endless_excluded_end_is_forbiden, scope: %i[period free_period]) if to.nil? && range.exclude_end?
    # to = to.prev_day if range.exclude_end?
    raise ::ArgumentError, I18n.t(:start_is_equal_to_end, scope: %i[period free_period])     if range.exclude_end? && from && to && from == to
    raise ::ArgumentError, I18n.t(:start_is_greater_than_end, scope: %i[period free_period]) if from && to && from > to

    super(from, to, range.exclude_end?)
  end

  alias from first
  alias beginning first

  alias to last
  alias ending last

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
      super(ActivePeriod::Day.new(other))
    elsif other.class.ancestors.include?(ActivePeriod::FreePeriod)
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

  # @param other [ActivePeriod::FreePeriod] Any kind of ActivePeriod::FreePeriod object
  # @return [Boolean] true if period are equals, false otherwise
  # @raise ArgumentError if params other is not a ActivePeriod::FreePeriod of some kind
  def ==(other)
    raise ArgumentError unless other.class.ancestors.include?(ActivePeriod::FreePeriod)

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
    I18n.t(bounding_format,
           scope: %i[period free_period],
           from:  I18n.l(self.begin, format: format, default: nil),
           to:    I18n.l(self.end,   format: format, default: nil),
           ending: ending)
  end

  # If no block given, it's an alias to to_s
  # For a block {|from,to| ... }
  # @yieldparam from [DateTime|Nil] the start of the period
  # @yieldparam to [DateTime|Nil] the end of the period
  # @yieldparam exclude_end? [Boolean] is the ending of the period excluded
  def i18n(&block)
    return yield(from, to, exclude_end?) if block.present?

    to_s
  end

  private

  def bounding_format
    if self.begin.nil? && self.end.nil?
      :boundless_format
    elsif self.begin.nil?
      :beginless_format
    elsif self.end.nil?
      :endless_format
    else
      :default_format
    end
  end

  def ending
    if exclude_end?
      :excluded
    else
      :included
    end
  end

  def nilthy?(time)
    time.nil? || (time.is_a?(String) && time.empty?)
  end

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
