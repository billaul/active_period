require_relative 'standard_period.rb'
require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'belongs_to.rb'
require_relative 'belongs_to/week.rb'
require_relative 'belongs_to/month.rb'
require_relative 'belongs_to/quarter.rb'
require_relative 'belongs_to/year.rb'

module Period
  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @note One of the StandardPeriod defined in the gem
  class Week < Period::StandardPeriod
    include Period::HasMany::Days

    include Period::BelongsTo::Month
    include Period::BelongsTo::Quarter
    include Period::BelongsTo::Year

    def strftime(format)
      from.strftime(format)
    end

    def to_s(format: '%V - %G')
      strftime(format)
    end

    def i18n(&block)
      return yield(from, to) if block.present?

      I18n.t(:default_format,
             scope: i18n_scope,
             week:  strftime('%V'),
             year:  strftime('%G'))
    end

    def iso_date
      from + 3.days
    end

  end
end
