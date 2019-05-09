require_relative "standard_period.rb"
require_relative "has_many.rb"
require_relative "belongs_to.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "belongs_to/month.rb"
require_relative "belongs_to/year.rb"

class SmartPeriod::Month < SmartPeriod::StandardPeriod
  include SmartPeriod::HasMany::Days
  include SmartPeriod::HasMany::Weeks

  include SmartPeriod::BelongsTo::Quarter
  include SmartPeriod::BelongsTo::Year

  def strftime(format)
    self.from.strftime(format)
  end

  def to_s
    self.strftime("%m/%Y")
  end

  def i18n(format: '%B %Y')
    I18n.l(from, format: format).capitalize
  end
end
