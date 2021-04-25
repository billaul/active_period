module ActivePeriod
  module Comparable
    include ::Comparable

    def include?(other)
      case other
      when DateTime, Time, ActiveSupport::TimeWithZone
        include_time?(other)
      when Date
        include_period?(ActivePeriod::Day.new(other))
      when ActivePeriod::FreePeriod
        include_period?(other)
      else
        raise ArgumentError, I18n.t(:incomparable_error, scope: :free_period)
      end
    end

    # @TODO support Limitless
    def <=>(other)
      if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
        to_i <=> other.to_i
      elsif self.class != other.class
        raise ArgumentError, I18n.t(:incomparable_error, scope: :free_period)
      else
        (from <=> other)
      end
    end

    private

    # this method could been shorten by chaining condition with ||
    # yet it would make it less readable
    def include_time?(other)
      return true if self.boundless?
      return true if self.endless? && self.begin <= other
      return true if self.beginless? && self.calculated_end >= other
      return true if self.begin.to_i <= other.to_i && other.to_i <= self.end.to_i
    end

    def include_period?(other)
      self.include_time?(other.begin) && self.include_time?(other.calculated_end) 
    end

  end
end
