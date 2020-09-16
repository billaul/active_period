require_relative 'standard_period.rb'
require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'has_many/quarters.rb'

module SmartPeriod
  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @note One of the StandardPeriod defined in the gem
  class Year < SmartPeriod::StandardPeriod
    include SmartPeriod::HasMany::Days
    include SmartPeriod::HasMany::Weeks
    include SmartPeriod::HasMany::Months
    include SmartPeriod::HasMany::Quarters

    def strftime(format)
      from.strftime(format)
    end

    def to_s(format: '%Y')
      strftime(format)
    end

    def i18n(&block)
      return yield(from, to) if block.present?

      I18n.t(:default_format,
             scope: i18n_scope,
             year:  from.year)
    end
  end
end
