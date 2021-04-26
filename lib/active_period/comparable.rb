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
      if other.is_a?(ActiveSupport::Duration) || other.is_a?(Numeric)
        to_i <=> other.to_i
      elsif self.class != other.class
        raise ArgumentError, I18n.t(:incomparable_error, scope: %i[active_period comparable])
      else
        (from <=> other)
      end
    end

    private

    # SI self day ou free < 7.jours
    # ET other week
    # ALORS include -> false
    # MAIS enumerator se sert de include et donc
    # self free < 7.jours SHOULD incldue week
    # Et en même temps non ><

    def include_period?(other)
      # TODO rewite this / make it more generic
      if (self.is_a?(Month) || self.is_a?(Quarter) || self.is_a?(Year)) && other.is_a?(Week)
        self.include_time?(other.include_date)
      elsif (other.is_a?(Month) || other.is_a?(Quarter) || other.is_a?(Year)) && self.is_a?(Week)
        other.include?(self.include_date)
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
      return true if self.begin.to_i <= other.to_i && other.to_i <= self.end.to_i
      false
    end

  end
end
