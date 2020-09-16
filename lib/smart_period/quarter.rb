require_relative 'standard_period.rb'
require_relative 'has_many.rb'
require_relative 'has_many/days.rb'
require_relative 'has_many/weeks.rb'
require_relative 'has_many/months.rb'
require_relative 'belongs_to.rb'
require_relative 'belongs_to/year.rb'

module SmartPeriod
  # @author Lucas Billaudot <billau_l@modulotech.fr>
  # @note One of the StandardPeriod defined in the gem
  class Quarter < SmartPeriod::StandardPeriod
    include SmartPeriod::HasMany::Days
    include SmartPeriod::HasMany::Weeks
    include SmartPeriod::HasMany::Months

    include SmartPeriod::BelongsTo::Year

    def strftime(format)
      format = format.gsub(':quarter', quarter_nb.to_s)
      from.strftime(format)
    end

    def quarter_nb
      @quarter_nb ||= (from.month / 3.0).ceil
    end

    def to_s
      i18n
    end

    def i18n(&block)
      return yield(from, to) if block.present?

      I18n.t(:default_format,
             scope: i18n_scope,
             quarter_nb:  quarter_nb,
             year:        from.year)
    end
  end
end
