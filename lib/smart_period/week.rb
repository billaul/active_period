require_relative "standard_period.rb"
require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "belongs_to.rb"
require_relative "belongs_to/week.rb"
require_relative "belongs_to/month.rb"
require_relative "belongs_to/quarter.rb"
require_relative "belongs_to/year.rb"

class SmartPeriod::Week < SmartPeriod::StandardPeriod
  include SmartPeriod::HasMany::Days

  include SmartPeriod::BelongsTo::Month
  include SmartPeriod::BelongsTo::Quarter
  include SmartPeriod::BelongsTo::Year

  def strftime(format)
    self.from.strftime(format)
  end

  def to_s(format: "%W - %Y")
    self.strftime(format)
  end

  def i18n(format: nil)
    if format.present?
      I18n.l(from, format: format)
    else
      I18n.t(:default_format,
             scope: [:standard_period, :week],
             week:  self.strftime("%W"),
             year:  self.strftime("%Y"))
    end
  end

end
