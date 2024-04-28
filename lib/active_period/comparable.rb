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
      when Range
        include?(other.first) && include?(other.last)
      else
        raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
      end
    end

    def <=>(other)
      case other
      when DateTime, Time, ActiveSupport::TimeWithZone
        if first < other && last < other
          -1
        elsif first > other && last > other
          1
        else
          0
        end
      when ActiveSupport::Duration, Numeric
        to_i <=> other.to_i
      else
        if self.class != other.class
          raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
        else
          (self.begin <=> other)
        end
      end
    end

    # Reverse clamp where the `other` is clamped by `self`
    #   If other is an ActivePeriod::Period then `clamp_on` will return an ActivePeriod::Period
    #   If other is not an ActivePeriod::Period then `clamp_on` will return a range
    def clamp_on(other)
      case other
      when DateTime, Time, ActiveSupport::TimeWithZone
        case self <=> other
        when -1
          last
        when 0
          other
        when 1
          first
        end
      when ActivePeriod::Period
        self & other
      when Range
        if (other.first > last && other.last > last) ||
           (other.first < first && other.last < first)
          return nil
        end

        clamped = clamp_on(other.first) .. clamp_on(other.last)

        if other.is_a? ActivePeriod::Period
          clamped.to_period
        else
          clamped
        end
      else
        raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
      end
      #
      # new_first = other.first < first ? first : other.first
      # new_last = other.last > last ? last : other.last
      #
      # if other.is_a? ActivePeriod::Period
      #   Period.new(new_first .. new_last)
      # else
      #   new_first .. new_last
      # end
    end

    private

    def include_period?(other)
      if self.class.in?([Month, Quarter, Year]) && other.is_a?(Week)
        self.include_time?(other.include_date)
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
