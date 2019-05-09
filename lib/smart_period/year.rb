require_relative "standard_period.rb"
require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "has_many/months.rb"
require_relative "has_many/quarters.rb"

class SmartPeriod::Year < SmartPeriod::StandardPeriod
  include SmartPeriod::HasMany::Days
  include SmartPeriod::HasMany::Weeks
  include SmartPeriod::HasMany::Months
  include SmartPeriod::HasMany::Quarters

  def strftime(format)
    self.from.strftime(format)
  end

  def to_s(format: "%Y")
    self.strftime(format)
  end

  def i18n(format: '%Y')
    I18n.l(from, format: format).capitalize
  end

end
