require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'
require_relative 'has_many/years.rb'

module ActivePeriod
  class FreePeriod < ActivePeriod::Period
    include ActivePeriod::HasMany::Days
    include ActivePeriod::HasMany::Weeks
    include ActivePeriod::HasMany::Months
    include ActivePeriod::HasMany::Quarters
    include ActivePeriod::HasMany::Years

    # Don't return an Integer. ActiveSupport::Duration is a better numeric
    # representation a in time manipulation context
    # @return [ActiveSupport::Duration] Number of day
    def to_i
      return Float::INFINITY if infinite?
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

    # @param format [String] A valid format for I18n.l
    # @return [String] Formated string
    def strftime(format)
      to_s(format: format)
    end

    # @param format [String] A valid format for I18n.l
    # @return [String] Formated string
    def to_s(format: '%d %B %Y')
      I18n.t(bounding_format,
             scope: %i[active_period free_period],
             from:  I18n.l(self.begin, format: format, default: nil),
             to:    I18n.l(self.end,   format: format, default: nil),
             ending: I18n.t(ending, scope: %i[active_period]))
    end

    def bounding_format
      if boundless?
        :boundless_format
      elsif beginless?
        :beginless_format
      elsif endless?
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

    # If no block given, it's an alias to to_s
    # For a block {|from,to| ... }
    # @yieldparam from [DateTime|Nil] the start of the period
    # @yieldparam to [DateTime|Nil] the end of the period
    # @yieldparam exclude_end? [Boolean] is the ending of the period excluded
    def i18n(&block)
      return yield(from, to, exclude_end?) if block.present?

      to_s
    end

  end
end
