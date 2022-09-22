module ActivePeriod
  module Comparable
    include ::Comparable

    def include?(other)
      case other
      when DateTime, Time, ActiveSupport::TimeWithZone
        include_time?(other)
      when Date
        include_period?(ActivePeriod::Day.new(other))
      when ActivePeriod::Period
        include_period?(other)
      else
        raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
      end
    end

    def <=>(other)
      raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable]) unless other.is_a?(ActiveSupport::Duration)

      if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
        to_i <=> other.to_i
      elsif self.class != other.class
        raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
      else
        (self.begin <=> other)
      end
    end

    private

    def include_period?(other)
      if self.class.in?([Month, Quarter, Year]) && other.is_a?(Week)
        self.include_time?(other.include_date)
      # elsif (other.class.in?([Month, Quarter, Year]) && self.is_a?(Week)
      #   other.include_time?(self.include_date)
      else
        self.include_time?(other.begin) && self.include_time?(other.calculated_end)
      end
    end

    # this method could been shorten by chaining condition with ||
    # yet it would make it less readable
    def include_time?(other)
      return true if self.boundless?
      return true if self.endless? && self.begin <= other
      return true if self.beginless? && self.calculated_end >= other
      return true if self.begin.to_i <= other.to_i && other.to_i <= self.calculated_end.to_i
      false
    end

  end
end
