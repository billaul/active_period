require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

module ActivePeriod
  class StandardPeriod < ActivePeriod::FreePeriod

    def initialize(object)
      time = time_parse(object,  I18n.t(:date_is_invalid, scope: %i[period standard_period]) )
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

    def iso_date
      from
    end

    # @raise NotImplementedError This method must be implemented id daughter class
    def to_s
      raise NotImplementedError
    end

    # @raise NotImplementedError This method must be implemented id daughter class
    def i18n
      raise NotImplementedError
    end

    def i18n_scope
      [:period, :standard_period, _period]
    end
  end
end
