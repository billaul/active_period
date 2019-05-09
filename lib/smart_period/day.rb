require_relative "standard_period.rb"
require_relative "belongs_to.rb"
require_relative "belongs_to/week.rb"
require_relative "belongs_to/month.rb"
require_relative "belongs_to/quarter.rb"
require_relative "belongs_to/year.rb"

class SmartPeriod::Day < SmartPeriod::StandardPeriod
  include SmartPeriod::BelongsTo::Week
  include SmartPeriod::BelongsTo::Month
  include SmartPeriod::BelongsTo::Quarter
  include SmartPeriod::BelongsTo::Year

  def strftime(format)
    self.from.strftime(format)
  end

  def to_s(format: "%d/%m/%Y")
    self.strftime(format)
  end

  def i18n(format:)
    I18n.l(from, format: format)
  end

end
