module ActivePeriod
  class StandardPeriod < ActivePeriod::Period

    def initialize(object)
      raise I18n.t(:base_class_id_abstract, scope: %i[active_period standard_period]) if self.class == StandardPeriod
      time = time_parse(object, I18n.t(:date_is_invalid, scope: %i[active_period standard_period]) )
      super(time.send("beginning_of_#{_period}")..time.send("end_of_#{_period}"))
    end

    def next
      self.class.new(from.send("next_#{_period}"))
    end
    alias succ next

    def prev
      self.class.new(from.send("prev_#{_period}"))
    end

    def _period
      self.class._period
    end

    # @return [String] get the name of the standard period
    def self._period
      name.split('::').last.downcase
    end

    # Don't realy return an Integer. ActiveSupport::Duration is a better numeric
    # representation a in time manipulation context
    # @return [ActiveSupport::Duration]
    def to_i
      1.send(_period)
    end

    # Shift a period to the past acording to her starting point
    # @return [self] A new period of the same kind
    def -(duration)
      self.class.new(from - duration)
    end

    # Shift a period to the past acording to her ending point
    # @return [self] A new period of the same kind
    def +(duration)
      self.class.new(to + duration)
    end

    def i18n_scope
      [:active_period, :standard_period, _period]
    end
  end
end
