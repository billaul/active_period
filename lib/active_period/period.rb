require_relative 'comparable.rb'
require_relative 'has_many/holidays.rb'

class ActivePeriod::Period < Range
  include ActivePeriod::Comparable
  include ActivePeriod::HasMany::Holidays

  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @param range [Range] A valid range
  # @param allow_beginless [Boolean] Is it allow to creat a beginless range
  # @param allow_endless [Boolean] Is it allow to creat an endless range
  # @return [self] A new instance of ActivePeriod::Period
  # @raise ArgumentError if the params range is not a Range
  # @raise ArgumentError if the params range is invalid
  def initialize(range, allow_beginless: true, allow_endless: true)
    I18n.t(:base_class_is_abstract, scope: %i[active_period period]) if self.class == ActivePeriod::Period

    raise ::ArgumentError, I18n.t(:param_must_be_a_range, scope: %i[active_period period]) unless range.class.ancestors.include?(Range)

    from = time_parse(range.begin, I18n.t(:begin_date_is_invalid, scope: %i[active_period period]))
    raise ::ArgumentError, I18n.t(:begin_date_is_invalid, scope: %i[active_period period]) if !allow_beginless && from.nil?
    from = from.try(:beginning_of_day) || from

    to = time_parse(range.end, I18n.t(:end_date_is_invalid, scope: %i[active_period period]))
    raise ::ArgumentError, I18n.t(:end_date_is_invalid, scope: %i[active_period period]) if !allow_endless && to.nil?
    to = to.try(:end_of_day) || to

    if range.exclude_end? && from && to && from.to_date == to.to_date
      raise ::ArgumentError, I18n.t(:start_is_equal_to_end_excluded, scope: %i[active_period period])
    end

    if from && to && from > to
      raise ::ArgumentError, I18n.t(:start_is_greater_than_end, scope: %i[active_period period])
    end

    super(from, to, range.exclude_end?)
  end

  alias from first
  alias beginning first

  alias to last
  alias ending last

  # @raise NotImplementedError This method cen be implemented in daughter class
  def next
    raise NotImplementedError
  end
  alias succ next

  # @raise NotImplementedError This method cen be implemented in daughter class
  def prev
    raise NotImplementedError
  end

  # @raise NotImplementedError This method should be implemented in daughter class
  def to_i
    raise NotImplementedError
  end

  # @raise NotImplementedError This method should be implemented in daughter class
  def -(duration)
    raise NotImplementedError
  end

  # @raise NotImplementedError This method should be implemented in daughter class
  def +(duration)
    raise NotImplementedError
  end

  # @param other [ActivePeriod::Period, ActiveSupport::Duration, Numeric] Any kind of ActivePeriod::Period, ActiveSupport::Duration or Numeric (in seconds)
  # @return [Boolean] true if period are equals, false otherwise
  # @raise ArgumentError if params other is not a ActivePeriod::Period of some kind
  def ==(other)
    if other.class.ancestors.include?(ActivePeriod::Period)
      from == other.from && self.calculated_end == other.calculated_end
    elsif other.is_a?(ActiveSupport::Duration)
      super(other)
    elsif other.is_a?(Numeric)
      super(other.seconds)
    else
      raise ArgumentError
    end
  end

  # @param other [ActivePeriod::Period] Any kind of ActivePeriod::Period object
  # @return [Boolean] true if period and class are the same, false otherwise
  # @raise ArgumentError if params other is not a ActivePeriod::Period of some kind
  def ===(other)
    self == other && self.class == other.class
  end

  # @param other [ActivePeriod::Period] Any kind of ActivePeriod::Period object
  # @return [ActivePeriod::Period, nil] Any kind of ActivePeriod::FreePeriod if period overlap, nil otherwise
  # @raise ArgumentError if params other is not a ActivePeriod::Period of some kind
  def &(other)
    raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable]) unless other.class.ancestors.include?(ActivePeriod::Period)

    # self            9------12
    # other  1-----------10
    if self.begin.in?(other) && !calculated_end.in?(other)
      Period.new( Range.new(self.begin, other.to, other.exclude_end?) )
    # self    1-----------10
    # other            9------12
    elsif !self.begin.in?(other) && calculated_end.in?(other)
      Period.new( Range.new(other.begin, to, exclude_end?) )
    # self      5-----8
    # other  1-----------10
    elsif other.include?(self)
      self
    # self   1-----------10
    # other      5-----8
    elsif self.include?(other)
      other
    else
      nil
    end
  end

  # @param other [ActivePeriod::Period] Any kind of ActivePeriod::Period object
  # @return [ActivePeriod::Period, nil] Any kind of ActivePeriod::FreePeriod if period overlap, nil otherwise
  # @raise ArgumentError if params other is not a ActivePeriod::Period of some kind
  def |(other)
    raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable]) unless other.class.ancestors.include?(ActivePeriod::Period)

    # overlapping or tail to head
    if self.begin.in?(other) || self.calculated_end.in?(other) || (
        ((self.calculated_end+1.day).beginning_of_day == other.from) ^
        ((other.calculated_end+1.day).beginning_of_day == self.from)
      )
      Period.new(
        Range.new(
          [self.begin, other.begin].min,
          [self.to, other.to].max,
          self.calculated_end > other.calculated_end ? self.exclude_end? : other.exclude_end?
        )
      )
    # no overlapping
    else
      nil
    end
  end

  # @raise NotImplementedError This method should be implemented in daughter class
  def strftime
    raise NotImplementedError
  end

  # @raise NotImplementedError This method should be implemented in daughter class
  def to_s
    raise NotImplementedError
  end

  # @raise NotImplementedError This method must be implemented in daughter class
  def i18n
    raise NotImplementedError
  end

  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @return [DateTime] The real value of end acording to exclude_end
  def calculated_end
    if endless?
      Date::Infinity.new
    else
      if exclude_end?
        self.end.prev_day
      else
        self.end
      end
    end
  end

  def calculated_begin
    if beginless?
      -Date::Infinity.new
    else
      self.begin
    end
  end

  def endless?
    self.end.nil?
  end

  def beginless?
    self.begin.nil?
  end

  def boundless?
    beginless? && endless?
  end

  def infinite?
    beginless? || endless?
  end

  private

  def time_parse(time, msg)
    time = time.presence
    case time
    when NilClass, Date::Infinity, Float::INFINITY, -Float::INFINITY
      nil
    when String, Date
      Period.env_time.parse(time.to_s)
    when Numeric
      Time.at time
    when Time, ActiveSupport::TimeWithZone
      time
    else
      raise ::ArgumentError, msg
    end
  rescue StandardError
    raise ::ArgumentError, msg
  end
end
