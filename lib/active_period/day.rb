require_relative 'standard_period.rb'
require_relative 'belongs_to.rb'
require_relative 'belongs_to/week.rb'
require_relative 'belongs_to/month.rb'
require_relative 'belongs_to/quarter.rb'
require_relative 'belongs_to/year.rb'

class ActivePeriod::Day < ActivePeriod::StandardPeriod
  include ActivePeriod::BelongsTo::Week
  include ActivePeriod::BelongsTo::Month
  include ActivePeriod::BelongsTo::Quarter
  include ActivePeriod::BelongsTo::Year

  def strftime(format)
    from.strftime(format)
  end

  def to_s(format: '%d/%m/%Y')
    strftime(format)
  end

  def i18n(&block)
    return yield(from, to) if block.present?

    I18n.t(:default_format,
           scope:   i18n_scope,
           wday:    I18n.l(from, format: '%A').capitalize,
           day:     from.day,
           month:   I18n.l(from, format: '%B').capitalize,
           year:    from.year)
  end
end
