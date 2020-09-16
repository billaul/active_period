require_relative 'standard_period.rb'
require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'belongs_to.rb'
require_relative 'belongs_to/quarter.rb'
require_relative 'belongs_to/year.rb'

# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note One of the StandardPeriod defined in the gem
module SmartPeriod
  class Month < SmartPeriod::StandardPeriod
    include SmartPeriod::HasMany::Days
    include SmartPeriod::HasMany::Weeks

    include SmartPeriod::BelongsTo::Quarter
    include SmartPeriod::BelongsTo::Year

    def strftime(format)
      from.strftime(format)
    end

    def to_s(format: '%m/%Y')
      strftime(format)
    end

    def i18n(&block)
      return yield(from, to) if block.present?

      I18n.t(:default_format,
             scope:  i18n_scope,
             month:  I18n.l(from, format: '%B').capitalize,
             year:   from.year)
    end
  end
end
